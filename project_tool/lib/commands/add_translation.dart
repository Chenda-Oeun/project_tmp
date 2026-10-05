import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:args/command_runner.dart';
import 'package:dart_style/dart_style.dart';
import 'package:ff/helpers.dart';
import 'package:interact/interact.dart';
import 'package:recase/recase.dart';
// import 'package:translator/translator.dart';

class AddTranslationCommand extends Command {
  @override
  String get description => 'Register translation.';

  @override
  String get name => 'tr';

  AddTranslationCommand() {
    argParser.addFlag('auto',
        abbr: 'a',
        defaultsTo: false,
        help: 'Translate all from google translate.');

    argParser.addFlag('yes-all',
        abbr: 'y', defaultsTo: false, help: 'Use all the default values.');
  }

  @override
  void run() async {
    final bool auto = argResults?['auto'];
    final bool yesAll = argResults?['yes-all'];
    await addTranslation(auto, yesAll);
  }

  static Future addTranslation(bool translateAll, bool yesAll) async {
    final config = await getConfig();

    final localeConfig = config['locale'];

    if (localeConfig == null) {
      printError('Locale config is not found in ff.yaml');
      exit(1);
    }

    final localePath = localeConfig['path'] ?? 'lib/data/locales/locale.dart';
    final languages = localeConfig['languages'];

    var localeFilePath = File(testablePath(localePath))
        .absolute
        .path
        .replaceAll(RegExp("[^/]+/\\.\\./"), '');

    final parsedUnitResult = parseFile(
      path: localeFilePath,
      featureSet: FeatureSet.latestLanguageVersion(),
    );

    final unit = parsedUnitResult.unit;

    var localeClass = unit.declarations.whereType<ClassDeclaration>().first;

    var fields = localeClass.members.whereType<FieldDeclaration>();

    var definedFieldNames = fields
        .map((FieldDeclaration e) => e.fields.variables.first.name.toString());

    var clipboardValue = await getFromClipboard();

    // Read input
    var englishWord = yesAll && clipboardValue.isNotEmpty
        ? clipboardValue
        : Input(
            prompt: 'English word (default: clipboard): ',
          ).interact();

    if (englishWord.isEmpty) {
      englishWord = await getFromClipboard();
    }

    if (englishWord.isEmpty) {
      printWarning('English word was empty, so no adding.');
      return;
    }

    printInfo(
        "Words: ${englishWord.substring(0, min(30, englishWord.length))}${englishWord.length > 30 ? '...' : ''}");

    var suggestKey = getSuggestKey(englishWord);

    var key = '';

    var useDefaultKey = yesAll;
    while (true) {
      key = useDefaultKey
          ? suggestKey
          : Input(
              prompt: 'Key (default: $suggestKey): ',
              defaultValue: suggestKey,
            ).interact();

      if (key.isEmpty) {
        printError('💡 Please input key that is not empty.💡');
      } else if (definedFieldNames.contains(key)) {
        await copyToClipboard("T.$key.r");
        printError('💡 Key $key already exists. Please choose another key.💡');
      } else if (!RegExp('^[a-z][a-zA-Z_0-9\$]*\$').hasMatch(key)) {
        printError(
            '💡 Key $key is not a valid variable. Please choose another key.💡');
      } else {
        await copyToClipboard("T.$key.r");
        break;
      }
      useDefaultKey = false;
    }

    // Add new code

    var codeResult =
        unit.toString().replaceAll("');", "',);").replaceAll('");', '",);');

    var addAfter = ');';
    var offset = 2; // ) and ;
    var match = RegExp("\\);[\\n\\s]*static").allMatches(codeResult);
    if (match.isNotEmpty) {
      addAfter = match.last.group(0)!;
    }
    var position = codeResult.lastIndexOf(addAfter);

    if (position == -1) {
      position = codeResult.indexOf('{');
    }

    var supportedLanguages = [];
    var baseLanguage = 'en';
    if (translateAll) {
      // final translator = GoogleTranslator();

      for (var language in languages) {
        final languageCode = language.split('_').first;
        final countryCode = language.split('_').last;

        if (languageCode == baseLanguage) continue;

        var target = languageCode;
        if (target == 'zh') {
          target += '-${ReCase(countryCode).paramCase}';
        }

        final translated = await translate(
          englishWord,
          from: baseLanguage,
          to: target,
        );

        String argKey = languageCode;
        if (countryCode == 'TW') {
          argKey = '${argKey}Tw';
        }
        supportedLanguages.add(
            "$argKey: '${translated.replaceAll("'", "\\'").replaceAll("\n", "\\n")}',");
      }
    }

    codeResult = '''
    ${codeResult.substring(0, position + offset)} 
    static const $key = _(
      en: '${englishWord.replaceAll("'", "\\'").replaceAll("\n", "\\n")}',${supportedLanguages.join('\n')}
    );
    ${codeResult.substring(position + offset, codeResult.length)}
    ''';

    final formatter = DartFormatter();
    final formattedCode = formatter.format(codeResult).replaceAll(");", ");\n");

    File(testablePath(localePath)).writeAsStringSync(formattedCode);
  }
}

String getSuggestKey(String englishWord) {
  var suggestKey = ReCase(englishWord).camelCase;
  if (suggestKey.length > 30) {
    suggestKey = suggestKey.substring(0, 30);
  }

  suggestKey = suggestKey
      .replaceAll(RegExp('[^a-zA-Z0-9_]'), '')
      .replaceAll(RegExp('_+'), '-');

  final replaceMap = {
    'please': 'pls',
    'button': 'btn',
  };

  var words = ReCase(suggestKey).sentenceCase.toLowerCase();

  for (var replace in replaceMap.keys) {
    words = words.replaceAll(replace, replaceMap[replace] ?? '');
  }

  return ReCase(words).camelCase;
}

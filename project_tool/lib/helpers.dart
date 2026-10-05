import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chalk/chalk.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;

Future copyToClipboard(String value) async {
  await runScript(
      'echo "${value.replaceAll('"', '\\"')}" | tr -d "\n"  | pbcopy',
      "Added $value to clipboard");
}

Future<String> getFromClipboard() async {
  final process = await Process.start('pbpaste', []);
  final stdoutStream = process.stdout.transform(utf8.decoder);
  var output = [];
  await for (final line in stdoutStream) {
    output.add(line);
  }
  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    return output.join('\n');
  } else {
    throw "Failed to paste";
  }
}

Future replaceFile(
    Pattern pattern, String Function(Match) replace, String filePath) async {
  final file = File(filePath);
  var fileContent = await file.readAsString();
  fileContent = fileContent.replaceAllMapped(pattern, replace);
  await file.writeAsString(fileContent);
}

String getRandomString(int length) {
  final rnd = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        rnd.nextInt(chars.length),
      ),
    ),
  );
}

Future<dynamic> runScript(
  String script,
  String description, {
  bool printExitCode = true,
}) async {
  // printWarning("Running:\n   ${script.split('\n').map((e) => '  $e').join('\n')}");

  // printInfo("Running: $script");

  String? result;
  String scriptContent = '''
#!/bin/bash
${Platform.isLinux ? 'LC_ALL=C;' : ''}
$script
''';

  // Get the system's temporary directory
  Directory tempDir = Directory.systemTemp;

  // Create a new temporary file in the temporary directory
  File tempFile = await File(
          '${tempDir.path}/temp_dart_tool_script_${getRandomString(10)}.sh')
      .create();

  // Write the script to the temporary file
  await tempFile.writeAsString(scriptContent);

  // Make the temporary file executable
  await Process.run('chmod', ['+x', tempFile.path]);

  // Run the script
  Process process = await Process.start(tempFile.path, [], runInShell: true);

  // Stream stdout to console
  process.stdout.transform(utf8.decoder).listen((data) {
    print(data);
    result = data;
  });

  // Stream stderr to console
  process.stderr.transform(utf8.decoder).listen((data) {
    printError(data);
  });

  // Wait for the process to exit
  int exitCode = await process.exitCode;
  if (exitCode == 0) {
    if (description.isNotEmpty) {
      printSuccess("Done $description! ✔");
    }
  } else {
    if (printExitCode) {
      printError('$description returns exit code $exitCode ✘');
    }
  }

  // Delete the temporary file
  if (tempFile.existsSync()) {
    tempFile.deleteSync(recursive: true);
  }

  return exitCode;
}

void printInfo(dynamic message) {
  print(chalk.blue(message.toString()));
}

void printSuccess(dynamic message) {
  print(chalk.green(message.toString()));
}

void printError(dynamic message) {
  print(chalk.red(message.toString()));
}

void printWarning(dynamic message) {
  print(chalk.yellow(message.toString()));
}

bool isDebug() {
  var debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  return debug;
}

String testablePath(String path) {
  return join(isDebug() ? '../' : '', path);
}

Future<dynamic> getConfig() async {
  final configFile = File(testablePath('ff.yaml'));
  if (!configFile.existsSync()) {
    printError('ff.yaml is not found in the root Flutter project');
    exit(1);
  }
  var doc = loadYaml(configFile.readAsStringSync());
  return doc;
}

Future<String> getFlutterRunnable() async {
  final config = await getConfig();
  if (config['build_settings']['flutter_sdk_path'] != null) {
    return config['build_settings']['flutter_sdk_path'];
  } else {
    return 'flutter';
  }
}

void showTextInFile(Pattern pattern, File file) {
  try {
    var text = findTextInFile(pattern, file);
    print(chalk.green('\n 📁 ') + chalk.blue(file.path));
    print(wrapTextInBox(text));
  } catch (e) {
    if (e is PathNotFoundException) {
      print(chalk.red(' ✗ ') +
          chalk.yellow('File ${file.path} does not exist!!'));
    } else {
      print(e);
    }
  }
}

String findTextInFile(Pattern pattern, File file) {
  var content = file.readAsStringSync();
  var matches = pattern.allMatches(content);
  if (matches.isEmpty) {
    throw chalk.red('Unable to find pattern /') +
        chalk.yellow(
            pattern.toString() + chalk.red('/ in ') + chalk.yellow(file.path));
  }
  var match = matches.first;
  return match.group(0)!;
}

String _makeStrings(String char, int count) {
  if (count == 0) {
    return '';
  }
  return List.generate(count, (index) => char).join('');
}

String wrapTextInBox(String text) {
  if (text.isEmpty) {
    text = '(Empty)';
  }

  // Replace tab by 2 spaces
  text = text.replaceAll('\t', '  ');

  // Remove empty line
  var lines = text.split('\n').map((e) => e.trimRight()).toList()
    ..removeWhere((line) => line.isEmpty);

  // Remove margin left
  while (lines.every((line) => line.startsWith(' '))) {
    lines = lines.map((e) => e.substring(1)).toList();
  }

  var maxLength = lines.map((e) => e.length).reduce(max);
  var totalLines = lines.length;

  lines.insert(0, chalk.cyan('╔═${_makeStrings('═', maxLength)}═╗'));
  for (var i = 1; i <= totalLines; i++) {
    lines[i] = chalk.cyan('║ ') +
        chalk.cyan(lines[i], ftFace: ChalkFtFace.bold) +
        _makeStrings(' ', maxLength - lines[i].length) +
        chalk.cyan(' ║');
  }
  lines.add(chalk.cyan('╚═${_makeStrings('═', maxLength)}═╝'));
  return lines.join('\n');
}

Future<String> translate(
  String text, {
  required String from,
  required String to,
}) async {
  const apiKey = 'AIzaSyCykhY5eO895RnYYLdNx8r3-o1GmCxnma4';
  final url = Uri.parse(
    'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'q': text,
      'source': from,
      'target': to,
      'format': 'text',
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(
      response.body,
    )['data']['translations'][0]['translatedText'];
  } else {
    throw Exception('Failed to translate text');
  }
}

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';

import 'set_app_version.dart';

class GenerateAssetVarCommand extends Command {
  @override
  String get description => 'Generate asset constants to AppAssets class.';

  @override
  String get name => 'asset';

  GenerateAssetVarCommand() {
    // argParser.addFlag('manual',
    //     abbr: 'm',
    //     defaultsTo: false,
    //     help: 'Do not check diff from git. Use list in asset_list.txt directly');
  }

  @override
  void run() async {
    // final bool manual = argResults?['manual'];
    await generateAssetVars();
  }

  static Future generateAssetVars() async {
    final config = await getConfig();

    final assetPaths = config['asset'];

    if (assetPaths == null) {
      printError('No [asset] specified in ff.yaml');
      exit(1);
    }
    if (assetPaths['paths'] is YamlList) {
      printInfo("Scanning asset files");

      var classPath = 'lib/utils/constants/assets.dart';
      var className = 'AppAssets';
      if (assetPaths['class'] != null) {
        if (assetPaths['class']['path'] is String) {
          classPath = assetPaths['class']['path'];
        }
        if (assetPaths['class']['name'] is String) {
          className = assetPaths['class']['name'];
        }
      }

      var code = '''import 'package:pos/utils/helpers/accessors.dart';
      
class $className {
  const $className._();''';

      var lightMapping = [];
      var darkMapping = [];
      var assetKeys = [];
      for (var path in assetPaths['paths']) {
        var variables = [];

        final files = Glob(testablePath(path));
        var group = '';

        for (var file in files.listSync()) {
          var directory = dirname(file.path);

          final darkPath = join(directory, 'dark');

          final hasDarkFolder = Directory(darkPath).existsSync();

          var fileName = basename(file.path);

          if (fileName.startsWith('.') || !fileName.contains('.')) {
            continue;
          }

          var dir = dirname(file.path).replaceFirst(RegExp("^\\./"), "");
          if (isDebug()) {
            dir = dir.replaceFirst(RegExp("^\\.\\./"), "");
          }

          var assetPath = join(dir, fileName);
          var fileDir = dir.split("/").last;
          if (group.isEmpty) {
            group = '  // ${ReCase(fileDir).sentenceCase}\n';
          }

          var suffix = '';
          if (fileDir.isNotEmpty) {
            suffix = fileDir;
            if (suffix != 's') {
              suffix = suffix.replaceFirst(RegExp('s\$'), '');
            }
          }

          var baseName = fileName.split('.');
          if (baseName.length > 1) {
            baseName.removeLast();
          }
          if (suffix.isNotEmpty) {
            baseName.add(suffix);
          }

          var rc = ReCase(baseName.join('_'));

          print("Checking on ${join(darkPath, fileName)}");

          if (hasDarkFolder && File(join(darkPath, fileName)).existsSync()) {
            final darkAssetPath = join(dir, 'dark/$fileName');
            darkMapping.add("    '${rc.camelCase}': '$darkAssetPath',");
          }

          lightMapping.add("    '${rc.camelCase}': '$assetPath',");
          assetKeys.add(rc.camelCase);
          variables.add(
              "  static String get ${rc.camelCase} => resolve('${rc.camelCase}');");
          // variables.add("  static const ${rc.camelCase} = '$assetPath';");
        }
        if (variables.isNotEmpty) {
          code += "\n\n$group${variables.join('\n')}";
        }
      }

      code += '''

  static String resolve(String key) {
    if (appSetting.inner.isDarkMode) {
      return _darkAsset[key] ?? _lightAsset[key]!;
    } else {
      return _lightAsset[key]!;
    }
  }
 
  static const _lightAsset = {
${lightMapping.join('\n')}
  };
  
  static const _darkAsset = {
${darkMapping.join('\n')}
  };
}

class AppAssetKeys {
  final String assetKey;

  String toAsset() {
    return AppAssets.resolve(assetKey);
  }
  
  List<String> allPath() {
    return [
      if (AppAssets._darkAsset.containsKey(assetKey))
        AppAssets._darkAsset[assetKey]!,
      if (AppAssets._lightAsset.containsKey(assetKey))
        AppAssets._lightAsset[assetKey]!,
    ];
  }
  
${assetKeys.map((e) => "  const AppAssetKeys.$e() : assetKey = '$e';").join('\n')}
}
''';

      var constFile = File(testablePath(classPath));

      printInfo("Writing to ${constFile.path}");

      await constFile.writeAsString(
        code,
        mode: FileMode.write,
      );

      printSuccess("Asset constants generated successfully 🎉");
    } else {
      printError('No [asset.paths] specified in ff.yaml');
      exit(1);
    }
  }
}

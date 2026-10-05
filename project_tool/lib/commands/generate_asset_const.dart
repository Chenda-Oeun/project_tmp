import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';


class GenerateAssetConstCommand extends Command {
  @override
  String get description => 'Generate asset constants to AppAssets class.';

  @override
  String get name => 'asset';

  GenerateAssetConstCommand() {
    // argParser.addFlag('manual',
    //     abbr: 'm',
    //     defaultsTo: false,
    //     help: 'Do not check diff from git. Use list in asset_list.txt directly');
  }

  @override
  void run() async {
    // final bool manual = argResults?['manual'];
    await generateAssetConstants();
  }

  static Future generateAssetConstants() async {
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

      var code = '''
class $className {
  const $className._();''';

      for (var path in assetPaths['paths']) {
        var variables = [];
        final files = Glob(testablePath(path));
        var group = '';

        for (var file in files.listSync()) {
          var fileName = basename(file.path);

          if (fileName.startsWith('.')) {
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

          variables.add("  static const ${rc.camelCase} = '$assetPath';");
        }
        if (variables.isNotEmpty) {
          code += "\n\n$group${variables.join('\n')}";
        }
      }

      code += '\n}';

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

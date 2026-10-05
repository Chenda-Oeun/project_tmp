import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';
import 'dart:io' show File, Platform;

class SetAppVersionCommand extends Command {
  @override
  String get description =>
      'Set app version and build number manually or follow ff.yaml';

  @override
  String get name => 'set-version';

  SetAppVersionCommand() {
    argParser.addOption('version', abbr: 'v');
    argParser.addOption('build', abbr: 'b');
  }

  @override
  void run() async {
    final config = await getConfig();

    final String versionName =
        argResults?['version'] ?? config['build_settings']['version']['name'];
    final String buildNumber =
        argResults?['build'] ?? config['build_settings']['version']['number'];
    final String patchVersion =
        argResults?['build'] ?? config['build_settings']['version']['patch'];

    await setVersion(versionName, buildNumber, patchVersion: patchVersion);
  }

  static Future setVersion(
    String versionName,
    String buildNumber, {
    required String patchVersion,
  }) async {
    final isMac = Platform.isMacOS;
    final command = isMac ? 'sed -i "" -E' : 'sed -i -E';

    await runScript('''
$command "s/^version\\: *.+/version: $versionName+$buildNumber/" pubspec.yaml

#android
if test -f android/local.properties; then
  $command "s/^flutter.versionName=.+/flutter.versionName=$versionName/" android/local.properties
  $command "s/^flutter.versionCode=.+/flutter.versionCode=$buildNumber/" android/local.properties
else
  echo "android/local.properties not yet created, it's okay if you don't need to build locally."
fi

#ios
if test -f ios/Flutter/flutter_export_environment.sh; then
  $command "s/FLUTTER_BUILD_NAME=[^\\"]+/FLUTTER_BUILD_NAME=$versionName/" ios/Flutter/flutter_export_environment.sh
  $command "s/FLUTTER_BUILD_NUMBER=[^\\"]+/FLUTTER_BUILD_NUMBER=$buildNumber/" ios/Flutter/flutter_export_environment.sh
else
  echo "ios/Flutter/flutter_export_environment.sh not yet created, this file only created by building ios"
fi

if test -f ios/Flutter/Generated.xcconfig; then
  $command "s/FLUTTER_BUILD_NAME=[^\\"]+/FLUTTER_BUILD_NAME=$versionName/" ios/Flutter/Generated.xcconfig
  $command "s/FLUTTER_BUILD_NUMBER=[^\\"]+/FLUTTER_BUILD_NUMBER=$buildNumber/" ios/Flutter/Generated.xcconfig
else
  echo "ios/Flutter/Generated.xcconfig not yet generated, this file only created by building ios"
fi

$command "s/MARKETING_VERSION = .+;/MARKETING_VERSION = $versionName;/g" ios/Runner.xcodeproj/project.pbxproj
$command "s/CURRENT_PROJECT_VERSION = .+;/CURRENT_PROJECT_VERSION = $buildNumber;/g" ios/Runner.xcodeproj/project.pbxproj

$command "s/const[ \\t]+int[ \\t]+patchVersion[ \\n\\t]*=[ \\n\\t]*[^;]+;/const int patchVersion = $patchVersion;/" lib/utils/core/config.gen.dart
    ''', 'Update version and build number');

    showTextInFile(
      RegExp(
        r'version\: *.+',
        multiLine: false,
      ),
      File('pubspec.yaml'),
    );

    showTextInFile(
      RegExp(
        r'flutter.versionName=.+',
        multiLine: false,
      ),
      File('android/local.properties'),
    );

    showTextInFile(
      RegExp(r'FLUTTER_BUILD_NAME=[^\"]+'),
      File('ios/Flutter/flutter_export_environment.sh'),
    );

    showTextInFile(
      RegExp(r'FLUTTER_BUILD_NAME=[^\"^\n]+'),
      File('ios/Flutter/Generated.xcconfig'),
    );

    showTextInFile(
      RegExp(r'MARKETING_VERSION = [^;]+;'),
      File('ios/Runner.xcodeproj/project.pbxproj'),
    );

    // showTextInFile(
    //   RegExp(r'const[ \t]+int[ \t]+patchVersion[ \n\t]*=[ \n\t]*[^;]+;'),
    //   File('lib/utils/core/config.gen.dart'),
    // );
  }
}

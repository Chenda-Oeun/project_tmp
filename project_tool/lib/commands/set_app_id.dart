import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';
import 'dart:io' show File, Platform;

class SetAppIdCommand extends Command {
  @override
  String get description =>
      'Set bundle ID for ios and package name for Android.';

  @override
  String get name => 'set-appid';

  SetAppIdCommand() {
    argParser.addOption('android',
        abbr: 'a',
        mandatory: false,
        help: 'Android package name. If not set, will not affect anything.');
    argParser.addOption('ios',
        abbr: 'i',
        mandatory: false,
        help: 'iOS app ID. If not set, will not affect anything.');
  }

  @override
  void run() async {
    final String? packageName = argResults?['android'];
    final String? bundleId = argResults?['ios'];

    if (packageName == null && bundleId == null) {
      printWarning('Nothing changed!!');
      return;
    }

    await setAppId(packageName, bundleId);
  }

  static Future setAppId(String? packageName, String? bundleId) async {
    if (bundleId != null) {
      await replaceFile(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER *= *[^;]+;'),
        (match) {
          if (match.group(0)!.endsWith('.RunnerTests;')) {
            return 'PRODUCT_BUNDLE_IDENTIFIER = $bundleId.RunnerTests;';
          }
          return 'PRODUCT_BUNDLE_IDENTIFIER = "$bundleId";';
        },
        'ios/Runner.xcodeproj/project.pbxproj',
      );

      // Info.plist
      await replaceFile(
        RegExp(
          r'([\n\s]*)<key>CFBundleURLName</key>[\n\s]*<string>([^<]+)</string>',
          multiLine: true,
          dotAll: true,
        ),
            (match) {
          return '''${match.group(1)}<key>CFBundleURLName</key>${match.group(1)}\t<string>$bundleId</string>''';
        },
        'ios/Runner/Info.plist',
      );
    }

    showTextInFile(
      RegExp(
        r'([\n\s]*)<key>CFBundleURLName</key>[\n\s]*<string>([^<]+)</string>',
        multiLine: true,
        dotAll: true,
      ),
      File('ios/Runner/Info.plist'),
    );

    showTextInFile(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER *= *[^;]+;',
        multiLine: true,
        dotAll: false,
      ),
      File('ios/Runner.xcodeproj/project.pbxproj'),
    );

    printSuccess('Update bundle ID successfully!');

    if (packageName != null) {
      final isMac = Platform.isMacOS;
      final command = isMac ? 'sed -i "" -E' : 'sed -i -E';

      await runScript('''
      $command "s/  package=\\"[^\\"]+\\"/  package=\\"$packageName\\"/" "android/app/src/main/AndroidManifest.xml" &&
      $command "s/  package=\\"[^\\"]+\\"/  package=\\"$packageName\\"/" "android/app/src/debug/AndroidManifest.xml" &&
      $command "s/  package=\\"[^\\"]+\\"/  package=\\"$packageName\\"/" "android/app/src/profile/AndroidManifest.xml" &&
      $command "s/  namespace ?= ?\\"[^\\"]+\\"/  namespace = \\"$packageName\\"/" "android/app/build.gradle" &&
      $command "s/  applicationId ?= ?\\"[^\\"]+\\"/  applicationId = \\"$packageName\\"/" "android/app/build.gradle" &&
      $command "s/package .+/package $packageName/" "android/app/src/main/kotlin/co/drtech/posapp/pos/MainActivity.kt"
''', 'Replace package name for android');
    }

    // showTextInFile(
    //   RegExp(
    //     r'package=\"[^\"]+\"',
    //     multiLine: true,
    //     dotAll: false,
    //   ),
    //   File('android/app/src/main/AndroidManifest.xml'),
    // );

    showTextInFile(
      RegExp(
        r'namespace = "[^"]+"',
        multiLine: true,
        dotAll: false,
      ),
      File('android/app/build.gradle'),
    );

    showTextInFile(
      RegExp(
        r'applicationId = "[^"]+"',
        multiLine: true,
        dotAll: false,
      ),
      File('android/app/build.gradle'),
    );

  }
}

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';

class SetAppNameCommand extends Command {
  @override
  String get description =>
      'Set application name to be displayed on home screen.';

  @override
  String get name => 'set-appname';

  SetAppNameCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      mandatory: true,
      help: 'Application name',
    );
  }

  @override
  void run() async {
    final String name = argResults?['name'];

    await setAppName(name);
  }

  static Future setAppName(String name) async {
    // var setName = '''perl -i -p0e "s/(<string name=\\"appLabel\\">)[^<]+/\\1\$DISPLAY_NAME/" android/app/src/main/res/values/strings.xml''';

    await runScript('''
DISPLAY_NAME="$name"
echo "Set display app name : \$DISPLAY_NAME"

#  ios/Runner/Info.plist
#  CFBundleDisplayName
perl -i -p0e "s/(<key>CFBundleDisplayName<\\/key>\\n\\s*<string>)[^<]+/\\1\$DISPLAY_NAME/" ios/Runner/Info.plist
#  CFBundleName
perl -i -p0e "s/(<key>CFBundleName<\\/key>\\n\\s*<string>)[^<]+/\\1\$DISPLAY_NAME/" ios/Runner/Info.plist

#  android/app/src/main/AndroidManifest.xml
#  <application android:label
perl -i -p0e "s/(<application(\\n\\s*.*)+android:label=\\")[^\\"]+/\\1\$DISPLAY_NAME/" android/app/src/main/AndroidManifest.xml

# lib/utils/core/app.dart
# MaterialApp title
perl -i -p0e "s/(MaterialApp\\(\\s*\\n\\s*title\\:\\s*)[^,]+/\\1'\$DISPLAY_NAME'/" lib/utils/core/app.dart
    ''', 'Update app name');

    showTextInFile(
      RegExp(
        r'\s*<key>CFBundleName</key>[\n\s]*<string>[^<]+',
        multiLine: true,
        dotAll: false,
      ),
      File('ios/Runner/Info.plist'),
    );

    showTextInFile(
      RegExp(
        r'\s*<key>CFBundleDisplayName</key>[\n\s]*<string>[^<]+',
        multiLine: true,
        dotAll: false,
      ),
      File('ios/Runner/Info.plist'),
    );

    showTextInFile(
      RegExp(
        r'[\n\s]*android:label="[^"]+"',
        multiLine: true,
        dotAll: false,
      ),
      File('android/app/src/main/AndroidManifest.xml'),
    );

    showTextInFile(
      RegExp(
        r'([^\n]*MaterialApp\(\s*\n\s*title:\s*)[^,]+',
        multiLine: true,
        dotAll: false,
      ),
      File('lib/utils/core/app.dart'),
    );
  }
}

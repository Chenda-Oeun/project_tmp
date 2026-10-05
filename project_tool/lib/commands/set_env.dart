import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ff/commands/set_app_id.dart';
import 'package:ff/commands/set_app_name.dart';
import 'package:ff/helpers.dart';

import 'set_app_version.dart';

class SetEnvironmentCommand extends Command {
  @override
  String get description => 'Change environment to test or production.';

  @override
  String get name => 'set-env';

  SetEnvironmentCommand() {
    argParser.addOption(
      'env',
      abbr: 'e',
      mandatory: true,
      allowed: ['dev', 'test', 'prod'],
      help:
          '[dev] refer to developer version. \n[test] for build but point to staging server. \n[prod] for release',
    );
  }

  @override
  void run() async {
    var env = argResults?['env'];

    await setEnv(env);
  }

  static Future setEnv(String env) async {
    final config = await getConfig();
    String envMode = env;

    // switch (env) {
    //   case 'dev':
    //     devMode = true;
    //     break;
    //   case 'test':
    //     devMode = true;
    //     break;
    //   case 'prod':
    //     devMode = false;
    //     break;
    //   default:
    // }

    final version = config['build_settings']['version']['name'];
    final buildNumber = config['build_settings']['version']['number'];
    final patchVersion = config['build_settings']['version']['patch'];

    SetAppVersionCommand.setVersion(
      '$version',
      '$buildNumber',
      patchVersion: '$patchVersion',
    );

    await replaceFile(
      RegExp(r'.*isTest = [^;]*;'),
      (match) {
        return "const isTest = ${envMode != 'test' ? 'false' : 'true'};";
      },
      'lib/utils/core/config.dart',
    );

    showTextInFile(
      RegExp(
        r'.*isTest[^;]*;',
        multiLine: true,
        dotAll: false,
      ),
      File('lib/utils/core/config.dart'),
    );

    // await replaceFile(
    //     RegExp(r'(const|final|bool) +showFloatingDebugTool *=[ \n\t]*[^;]+;'),
    //     (match) {
    //   return "${match.group(1)} showFloatingDebugTool = !kReleaseMode;";
    // }, 'lib/utils/core/config.gen.dart');
    //
    // showTextInFile(
    //   RegExp(r'(const|final|bool) +showFloatingDebugTool *=[ \n\t]*[^;]+;'),
    //   File('lib/utils/core/config.gen.dart'),
    // );

    printSuccess('Updated config.dart variable! ✔');

    await SetAppNameCommand.setAppName(config['display_app_name'][envMode]);
    await SetAppIdCommand.setAppId(
        config['app_id']['android'][envMode], config['app_id']['ios'][envMode]);
    // await setGoogleApiKey(config['google_api_key']['android'][envMode],
    //     config['google_api_key']['ios'][envMode]);
  }
}

setGoogleApiKey(String android, String iOS) async {
  await replaceFile(
    RegExp(r'GMSServices\.provideAPIKey\("[^"]+"\)'),
    (match) {
      return 'GMSServices.provideAPIKey("$iOS")';
    },
    'ios/Runner/AppDelegate.swift',
  );

  showTextInFile(
    RegExp(r'GMSServices\.provideAPIKey\("[^"]+"\)'),
    File('ios/Runner/AppDelegate.swift'),
  );

  await replaceFile(
    RegExp(r'GMSPlacesClient\.provideAPIKey\("[^"]+"\)'),
    (match) {
      return 'GMSPlacesClient.provideAPIKey("$iOS")';
    },
    'ios/Runner/AppDelegate.swift',
  );

  showTextInFile(
    RegExp(r'GMSPlacesClient\.provideAPIKey\("[^"]+"\)'),
    File('ios/Runner/AppDelegate.swift'),
  );

  await replaceFile(
    RegExp(
      r'(<meta-data[\n\s]+android:name="com\.google\.android\.geo\.API_KEY"[\n\s]+)android:value=[^>]+>',
      multiLine: true,
      dotAll: true,
    ),
    (match) {
      return '${match.group(1)}android:value="$android"/>';
    },
    'android/app/src/main/AndroidManifest.xml',
  );

  showTextInFile(
    RegExp(
      r'(<meta-data[\n\s]+android:name="com\.google.\android\.geo\.API_KEY"[\n\s]+)android:value=[^>]+>',
      multiLine: true,
      dotAll: true,
    ),
    File('android/app/src/main/AndroidManifest.xml'),
  );

  await replaceFile(
      RegExp(
        r'String get googleMapApiKey[^}]+}',
        multiLine: true,
        dotAll: true,
      ), (match) {
    return '''String get googleMapApiKey {
  return Platform.isIOS
      ? '$iOS'
      : '$android';
}''';
  }, 'lib/utils/core/config.dart');

  showTextInFile(
    RegExp(
      r'String get googleMapApiKey[^}]+',
      multiLine: true,
      dotAll: true,
    ),
    File('lib/utils/core/config.dart'),
  );
}

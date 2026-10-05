
import 'package:args/command_runner.dart';
import 'package:ff/commands/add_translation.dart';
import 'package:ff/commands/auto_export.dart';
import 'package:ff/commands/compile_tool.dart';
import 'package:ff/commands/generate_asset_var.dart';
import 'package:ff/commands/set_env.dart';

void main(List<String> arguments) async {
  // GenerateAssetConstCommand.generateAssetConstants();
  // return;
  try {
    final runner = CommandRunner('ff', 'Command line for this project')
      ..addCommand(AutoExportCommand())
      ..addCommand(GenerateAssetVarCommand())
      ..addCommand(AddTranslationCommand())
      ..addCommand(CompileToolCommand())
      ..addCommand(SetEnvironmentCommand());

    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
  }
}

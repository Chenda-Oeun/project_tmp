import 'package:args/command_runner.dart';
import 'package:ff/helpers.dart';
import 'dart:io' show Platform;

class CompileToolCommand extends Command {
  @override
  String get description => 'Recompile the project tool command ff.';

  @override
  String get name => 'tool-compile';

  CompileToolCommand();

  @override
  void run() async {
    final isMac = Platform.isMacOS;

    final commandTarget = isMac ? './ff' : './ffarm';

    await runScript('''
cd project_tool;
dart compile exe bin/ff.dart -o ../fftmp;
mv ../fftmp .$commandTarget
''', 'Compile project tool');

    printSuccess("Please check $commandTarget");
  }
}

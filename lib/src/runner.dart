import 'package:args/command_runner.dart';
import 'package:husky/src/commands/add_set.dart';
import 'package:husky/src/commands/install.dart';
import 'package:husky/src/commands/uninstall.dart';

class Husky extends CommandRunner {

  Husky() : super('husky', 'Husky improves you Dart and Flutter project\'s git workflow.') {
    addCommand(AddSetCommand('add'));
    addCommand(AddSetCommand('set'));
    addCommand(InstallCommand());
    addCommand(UninstallCommand());
  }

}
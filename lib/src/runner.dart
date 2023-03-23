import 'package:args/command_runner.dart';

import 'commands/add_set.dart';
import 'commands/install.dart';
import 'commands/uninstall.dart';

///
/// Husky Command Runner
///
class HuskyRunner extends CommandRunner {
  HuskyRunner()
      : super('husky',
            'Husky improves you Dart and Flutter project\'s git workflow.') {
    addCommand(AddSetCommand('add'));
    addCommand(AddSetCommand('set'));
    addCommand(InstallCommand());
    addCommand(UninstallCommand());
  }
}

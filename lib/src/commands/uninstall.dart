import 'dart:io';

import 'package:args/command_runner.dart';

class UninstallCommand extends Command {
  @override
  String get description => 'Uninstall git hooks from project';

  @override
  String get name => 'uninstall';

  @override
  Future<void> run() async {
    Process.runSync('git', ['config', '--unset', 'core.hooksPath']);
  }

}
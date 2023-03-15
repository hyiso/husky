import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

class AddSetCommand extends Command {
  @override
  String get description =>
      '${name == 'add' ? 'Add' : 'Set'} script to a git hook';

  @override
  final String name;

  AddSetCommand(this.name);

  @override
  String get invocation =>
      'dart run ${runner!.executableName} $name <file> [cmd]';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 2) {
      printUsage();
      return;
    }
    final path = argResults!.rest.first;
    final cmd = argResults!.rest.elementAt(1);
    if (name == 'add') {
      await add(path, cmd);
    } else {
      await set(path, cmd);
    }
  }

  Future<void> add(String path, String cmd) async {
    final file = File(path);
    if (file.existsSync()) {
      file.writeAsStringSync('$cmd\n', mode: FileMode.append);
      stderr.writeln('husky - updated ${file.path}');
    } else {
      await set(file.path, cmd);
    }
  }

  Future<void> set(String path, String cmd) async {
    final dir = dirname(path);
    if (!Directory(dir).existsSync()) {
      throw Exception(
          'can\'t create hook, $dir directory doesn\'t exist (try running husky install)');
    }
    File(path).writeAsStringSync('''
#!/usr/bin/env sh
. "\$(dirname -- "\$0")/_/husky.sh"

$cmd
''');
    if (!Platform.isWindows) {
      Process.runSync('chmod', ['755', path]);
    }
  }
}

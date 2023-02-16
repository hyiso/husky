import 'dart:io';
import 'package:path/path.dart';

String tmp() {
  final tmp = Directory.systemTemp.path;
  return join(
      tmp, 'tmp', 'husky_test_${DateTime.now().millisecondsSinceEpoch}');
}

Future<void> setupGit(String dir) async {
  /// Git init
  await Process.run('git', ['init', dir]);

  /// Git config
  await Process.run('git', ['config', 'user.name', 'test'],
      workingDirectory: dir);
  await Process.run('git', ['config', 'user.email', 'test@example.com'],
      workingDirectory: dir);
  await Process.run('git', ['config', 'commit.gpgsign', 'false'],
      workingDirectory: dir);
}

Future<void> setupPackage(String dir) async {
  if (!await Directory(dir).exists()) {
    await Directory(dir).create(recursive: true);
  }

  /// Create dart package
  await Process.run('dart', ['create', '-t', 'package', '.', '--force'],
      workingDirectory: dir);

  /// Add husky to dev_dependencies
  await Process.run('dart',
      ['pub', 'add', '--dev', 'husky', '--path', Directory.current.path],
      workingDirectory: dir);
}

Future<ProcessResult> getHooksPath(String workingDirectory) async {
  return await Process.run('git', ['config', 'core.hooksPath'],
      workingDirectory: workingDirectory);
}

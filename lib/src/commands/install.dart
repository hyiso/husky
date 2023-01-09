import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:husky/src/logger.dart';
import 'package:path/path.dart';

class InstallCommand extends Command {
  @override
  String get description => 'Install git hooks to project';

  @override
  String get name => 'install';

  @override
  Future<void> run() async {
    // ignore: unrelated_type_equality_checks
    if (Platform.environment['HUSKY'] == 0) {
      logger.stderr('HUSKY env variable is set to 0, skipping install');
      return;
    }
    /// Ensure that we're inside a git repository
    /// If git command is not found, status is null and we should return.
    /// That's why status value needs to be checked explicitly.
    if ((Process.runSync('git', ['rev-parse'])).exitCode != 0) {
      logger.stderr('git command not found, skipping install');
      return;
    }
    String dir = '.husky';
    if (argResults!.rest.isNotEmpty) {
      dir = argResults!.rest.first;
    }
    if (!absolute(dir).startsWith(Directory.current.absolute.path)) {
      logger.stderr('.. install dir outside of cwd is not allowed.');
      return;
    }
    if (!Directory('.git').existsSync()) {
      throw Exception('.git can\'t be found.');
    }
    // Create .husky/_
    Directory(join(dir, '_')).createSync(recursive: true);

    // Create .husky/_/.gitignore
    File(join(dir, '_/.gitignore')).writeAsStringSync('*');

    // Copy husky.sh to .husky/_/husky.sh
    final packageUri = Uri.parse('package:husky/husky.sh');
    final uri = await Isolate.resolvePackageUri(packageUri);
    if (uri != null) {
      File.fromUri(uri).copySync(join(dir, '_/husky.sh'));
    }

    // Configure repo
    if (Process.runSync('git', ['config', 'core.hooksPath', dir]).exitCode != 0) {
      logger.stderr('Git hooks failed to install');
    } else {
      logger.stderr('Git hooks installed');
    }
    
  }

}
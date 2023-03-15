import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

class InstallCommand extends Command {
  @override
  String get description => 'Install git hooks.';

  @override
  String get name => 'install';

  @override
  String get invocation =>
      'dart run ${runner!.executableName} $name [dir] (default: .husky)';

  @override
  Future<void> run() async {
    if (Platform.environment['HUSKY'] == '0') {
      stderr
          .writeln('husky - HUSKY env variable is set to 0, skipping install');
      return;
    }

    /// Ensure that we're inside a git repository
    /// If git command is not found, status is null and we should return.
    /// That's why status value needs to be checked explicitly.
    if ((Process.runSync('git', ['rev-parse'])).exitCode != 0) {
      stderr.writeln(
          'husky - not a git repository (or any of the parent directories), skipping install');
      return;
    }
    String dir = '.husky';
    if (argResults!.rest.isNotEmpty) {
      dir = argResults!.rest.first;
    }
    if (!absolute(dir).startsWith(Directory.current.absolute.path)) {
      stderr.writeln('husky - .. install dir outside of cwd is not allowed.');
      return;
    }
    if (!Directory('.git').existsSync() && !File('.git').existsSync()) {
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
    if (Process.runSync('git', ['config', 'core.hooksPath', dir]).exitCode !=
        0) {
      stderr.writeln('husky - Git hooks failed to install');
    } else {
      stderr.writeln('husky - Git hooks installed');
    }
  }
}

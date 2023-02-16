import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('husky', () {
    test('should work by default', () async {
      final dir = tmp();
      print('default dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);

      /// Install
      await Process.run('dart', ['run', 'husky', 'install'],
          workingDirectory: dir);
      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals('.husky'));

      /// Add a hook
      await Process.run(
          'dart',
          [
            'run',
            'husky',
            'add',
            join('.husky', 'pre-commit'),
            'echo "pre-commit" && exit 1'
          ],
          workingDirectory: dir);
      await Process.run('git', ['add', 'pubspec.yaml'], workingDirectory: dir);
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));

      /// Uninstall
      await Process.run('dart', ['run', 'husky', 'uninstall'],
          workingDirectory: dir);
      result = await getHooksPath(dir);
      expect(result.exitCode, equals(1));
    });
    test('in custom dir should work', () async {
      final dir = tmp();
      print('custom dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);

      /// Install
      await Process.run('dart', ['run', 'husky', 'install', 'custom'],
          workingDirectory: dir);
      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals('custom'));

      /// Add a hook
      await Process.run(
          'dart',
          [
            'run',
            'husky',
            'add',
            join('custom', 'pre-commit'),
            'echo "pre-commit" && exit 1'
          ],
          workingDirectory: dir);
      await Process.run('git', ['add', 'pubspec.yaml'], workingDirectory: dir);
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
    test('in sub dir should work', () async {
      final dir = tmp();
      print('sub dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);
      final subDir = join(dir, 'sub');
      final subHusky = join('sub', '.husky');
      await setupPackage(subDir);

      /// Install
      await Process.run('dart', ['run', 'husky', 'install', subHusky],
          workingDirectory: dir);
      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals(subHusky));

      /// Add a hook in sub dir
      await Process.run(
          'dart',
          [
            'run',
            'husky',
            'add',
            join('.husky', 'pre-commit'),
            'echo "pre-commit" && exit 1'
          ],
          workingDirectory: subDir);
      await Process.run('git', ['add', 'pubspec.yaml'],
          workingDirectory: subDir);
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
    test('install in non-git dir should not fail', () async {
      final dir = tmp();
      print('non-git dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);
      await Process.run('rm', ['-rf', '.git'], workingDirectory: dir);

      /// Install
      var result = await Process.run('dart', ['run', 'husky', 'install'],
          workingDirectory: dir);
      expect(result.exitCode, equals(0));
    });
    test('set/add should work', () async {
      final dir = tmp();
      print('set/add dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);

      /// Install
      await Process.run('dart', ['run', 'husky', 'install'],
          workingDirectory: dir);

      final hook = join('.husky', 'pre-commit');
      final hookFile = File(join(dir, hook));

      /// Add hook
      await Process.run('dart', ['run', 'husky', 'add', hook, 'foo'],
          workingDirectory: dir);
      var content = await hookFile.readAsString();
      expect(content.contains('foo'), true);

      /// Add hook
      await Process.run('dart', ['run', 'husky', 'add', hook, 'bar'],
          workingDirectory: dir);
      content = await hookFile.readAsString();
      expect(content.contains('foo'), true);
      expect(content.contains('bar'), true);

      /// Add hook
      await Process.run('dart', ['run', 'husky', 'set', hook, 'baz'],
          workingDirectory: dir);
      content = await hookFile.readAsString();
      expect(content.contains('foo'), false);
      expect(content.contains('bar'), false);
      expect(content.contains('baz'), true);
    });
    test('hook with exitCode 127 should terminate', () async {
      final dir = tmp();
      print('exit-127 dir: $dir');

      /// Setup
      await setupGit(dir);
      await setupPackage(dir);

      /// Install
      await Process.run('dart', ['run', 'husky', 'install'],
          workingDirectory: dir);

      /// Add a hook
      await Process.run('dart',
          ['run', 'husky', 'add', join('.husky', 'pre-commit'), 'exit 127'],
          workingDirectory: dir);
      final result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
  });
}

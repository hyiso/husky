import 'dart:io';

import 'package:husky/husky.dart';
import 'package:path/path.dart' show join;
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  final husky = HuskyRunner();
  group('husky', () {
    test('should work by default', () async {
      final dir = tmp();
      print('default dir: $dir');

      /// Setup
      await setupGit(dir);

      Directory.current = Directory(dir);

      /// Install
      await husky.run(['install']);

      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals('.husky'));

      /// Add a hook
      await husky.run(
          ['add', join('.husky', 'pre-commit'), 'echo "pre-commit" && exit 1']);

      await Process.run('git', ['add', '.'], workingDirectory: dir);
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));

      /// Uninstall
      await husky.run(['uninstall']);
      result = await getHooksPath(dir);
      expect(result.exitCode, equals(1));
    });
    test('in custom dir should work', () async {
      final dir = tmp();
      print('custom dir: $dir');

      /// Setup
      await setupGit(dir);
      Directory.current = Directory(dir);

      /// Install
      await husky.run(['install', 'custom']);
      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals('custom'));

      /// Add a hook
      await husky.run(
          ['add', join('custom', 'pre-commit'), 'echo "pre-commit" && exit 1']);

      await Process.run('git', ['add', '.'], workingDirectory: dir);
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
    test('in sub dir should work', () async {
      final dir = tmp();
      print('sub dir: $dir');

      /// Setup
      await setupGit(dir);
      Directory.current = Directory(dir);

      /// Install
      await husky.run(['install', join('sub', '.husky')]);
      var result = await getHooksPath(dir);
      expect(result.exitCode, equals(0));
      expect(result.stdout.toString().trim(), equals(join('sub', '.husky')));

      /// Add a hook in sub dir
      await husky.run([
        'add',
        join('sub', '.husky', 'pre-commit'),
        'echo "pre-commit" && exit 1'
      ]);

      await Process.run('git', ['add', ''], workingDirectory: join(dir, 'sub'));
      result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
    test('install in non-git dir should not fail', () async {
      final dir = tmp();
      print('non-git dir: $dir');

      /// Setup
      await setupGit(dir);
      await Process.run('rm', ['-rf', '.git'], workingDirectory: dir);
      Directory.current = Directory(dir);

      expect(husky.run(['install']), completes);
    });
    test('set/add should work', () async {
      final dir = tmp();
      print('set/add dir: $dir');

      /// Setup
      await setupGit(dir);
      Directory.current = Directory(dir);

      /// Install
      await husky.run(['install']);

      final hook = join('.husky', 'pre-commit');
      final hookFile = File(join(dir, hook));

      /// Add hook
      await husky.run(['add', hook, 'foo']);
      var content = await hookFile.readAsString();
      expect(content.contains('foo'), true);

      /// Add hook
      await husky.run(['add', hook, 'bar']);
      content = await hookFile.readAsString();
      expect(content.contains('foo'), true);
      expect(content.contains('bar'), true);

      /// Add hook
      await husky.run(['set', hook, 'baz']);
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
      Directory.current = Directory(dir);

      /// Install
      await husky.run(['install']);

      /// Add a hook
      await husky.run(['add', join('.husky', 'pre-commit'), 'exit 127']);
      final result = await Process.run('git', ['commit', '-m', 'foo'],
          workingDirectory: dir);
      expect(result.exitCode, equals(1));
    });
  });
}

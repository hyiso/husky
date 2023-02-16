# husky

[![Pub Version](https://img.shields.io/pub/v/husky?color=blue)](https://pub.dev/packages/husky)
[![popularity](https://img.shields.io/pub/popularity/husky?logo=dart)](https://pub.dev/packages/husky/score)
[![likes](https://img.shields.io/pub/likes/husky?logo=dart)](https://pub.dev/packages/husky/score)
[![CI](https://github.com/hyiso/husky/actions/workflows/ci.yml/badge.svg)](https://github.com/hyiso/husky/actions/workflows/ci.yml)

> Dart version husky (Inspired by [JavaScript version husky](https://github.com/typicode/husky))

Husky make it easy to manage your Dart and Flutter project's git hooks.

You can use it to lint your commit messages, run tests, lint code, etc... when you commit or push. Husky supports [all Git hooks](https://git-scm.com/docs/githooks).

# Features

- Powered by modern new Git feature (`core.hooksPath`)
- User-friendly messages
- _Support_
  - macOS, Linux and Windows
  - Git GUIs
  - Custom directories
  - Monorepos


# Usage


1. Add husky to your `dev_dependencies` in pubspec.yaml
```shell
dart pub add --dev husky
```

2. Enable Git hooks.

```shell
dart run husky install
```
This will generate `.husky` directory under your project's root path.<br />
**Note: make sure to commit `.husky` to git repository.**

3. Create a hook:

```shell
dart run husky add .husky/pre-commit "dart test"
git add .husky/pre-commit
```

Try to make a commit:

```shell
git commit -m "Keep calm and commit"
# `dart test` will run
```

If `dart test` command fails, your commit will be automatically aborted.


## Uninstall
```shell
dart run husky uninstall
dart pub remove --dev husky
git config --unset core.hooksPath
```

# Recipes

## Monorepo

It's recommended to add husky in root `pubspec.yaml`. You can use tools like [melos](https://github.com/invertase/melos) and filters to only run scripts in packages that have been changed.

## Custom directory

If you want to install husky in another directory, for example `.config`, you can pass it to `install` command. For example:

```shell
dart run husky install .config/husky
```

Another case you may be in is if your `pubspec.yaml` file and `.git` directory are not at the same level. For example, `project/.git` and `project/sub/pubspec.yaml`.

By design, `husky install` must be run in the same directory as `.git`, but you can change directory when running `dart run husky install` and pass a subdirectory:

```shell
dart run husky install sub/.husky
```

In your hooks, you'll also need to change directory:

```shell
# .husky/pre-commit
# ...
cd sub
dart test
```

## Bypass hooks

You can bypass `pre-commit` and `commit-msg` hooks using Git `-n/--no-verify` option:

```shell
git commit -m "yolo!" --no-verify
```

For Git commands that don't have a `--no-verify` option, you can use `HUSKY` environment variable:

```shell
HUSKY=0 git push # yolo!
```

## Test hooks

If you want to test a hook, you can add `exit 1` at the end of the script to abort git command.

```shell
# .husky/pre-commit
# ...
exit 1 # Commit will be aborted
```

## Git-flow

If using [git-flow](https://github.com/petervanderdoes/gitflow-avh/) you need to ensure your git-flow hooks directory is set to use Husky's (`.husky` by default).

```shell
git config gitflow.path.hooks .husky
```

**Note:**

- If you are configuring git-flow _after_ you have installed husky, the git-flow setup process will correctly suggest the .husky directory.
- If you have set a [custom directory](/?id=custom-directory) for husky you need to specify that (ex. `git config gitflow.path.hooks .config/husky`)

To **revert** the git-flow hooks directory back to its default you need to reset the config to point to the default Git hooks directory.

```shell
git config gitflow.path.hooks .git/hooks
```

# FAQ

## Does it work on Windows?

Yes. When you install Git on Windows, it comes with the necessary software to run shell scripts.

# Troubleshoot

## Hooks not running

1. Ensure that you don't have a typo in your filename. For example, `precommit` or `pre-commit.sh` are invalid names. See Git hooks [documentation](https://git-scm.com/docs/githooks) for valid names.
1. Check that `git config core.hooksPath` returns `.husky` (or your custom hooks directory).
1. Verify that hook files are executable. This is automatically set when using `husky add` command but you can run `chmod +x .husky/<hookname>` to fix that.
1. Check that your version of Git is greater than `2.9`.\

## Cannot work with Gerrit as Change-Id is missing

You can create a `commit-msg` hook to call `.git/hooks/commit-msg`
```shell
dart run husky add .husky/commit-msg 'gitdir=$(git rev-parse --git-dir); ${gitdir}/hooks/commit-msg $1'
```

## .git/hooks/ not working after uninstall

If after uninstalling `husky`, hooks in `.git/hooks/` aren't working. Run `git config --unset core.hooksPath`.

# Articles
- [Use husky to manage git hooks for your Dart and Flutter projects](https://medium.com/p/dbb8e09caabf)
- [Use husky and commitlint to lint commit messages for your Dart and Flutter projects](https://medium.com/p/74b5d2757061)
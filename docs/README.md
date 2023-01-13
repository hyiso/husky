[![Pub Version](https://img.shields.io/pub/v/husky?color=blue)](https://pub.dev/packages/husky)
[![popularity](https://img.shields.io/pub/popularity/husky?logo=dart)](https://pub.dev/packages/husky/score)
[![likes](https://img.shields.io/pub/likes/husky?logo=dart)](https://pub.dev/packages/husky/score)
![building](https://github.com/hyiso/husky/actions/workflows/ci.yml/badge.svg)
[![style: lints](https://img.shields.io/badge/style-lints-blue)](https://pub.dev/packages/lints)

> Dart version husky (known in JavaScript comunity)

Husky make it easy to manage your Dart and Flutter project's git hooks.

# Install

Add husky to your `dev_dependencies` in pubspec.yaml

```yaml
dev_dependencies:
  husky: latest
```

# Usage

```sh
dart pub get
dart run husky install
```

Add a hook:

```sh
dart run husky add .husky/pre-commit "dart test"
git add .husky/pre-commit
```

Make a commit:

```sh
git commit -m "Keep calm and commit"
# `dart test` will run
```
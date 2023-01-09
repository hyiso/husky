# husky

> Dart version husky (known in JavaScript comunity)

Husky make it easy to manage you Dart and Flutter project's git hooks.

# Install

Add husky to your `dev_dependencies` in pubspec.yaml

```yaml
dev_dependencies:
  husky: latest
```

# Usage

```sh
dart pub get
dart pub run husky install
```

Add a hook:

```sh
dart pub run husky add .husky/pre-commit "dart test"
git add .husky/pre-commit
```

Make a commit:

```sh
git commit -m "Keep calm and commit"
# `dart test` will run
```
. "$(dirname -- "$0")/functions.sh"
setup
install

dart run husky install

# Test core.hooksPath
expect_hooksPath_to_be ".husky"

# Test pre-commit
git add pubspec.yaml
dart run husky add .husky/pre-commit "echo \"pre-commit\" && exit 1"
expect 1 "git commit -m foo"

# Uninstall
dart run husky uninstall
expect 1 "git config core.hooksPath"

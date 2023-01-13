. "$(dirname -- "$0")/functions.sh"
setup
install

# Test custom dir support
mkdir sub
dart run husky install sub/husky
dart run husky add sub/husky/pre-commit "echo \"pre-commit\" && exit 1"

# Test core.hooksPath
expect_hooksPath_to_be "sub/husky"

# Test pre-commit
git add pubspec.yaml
expect 1 "git commit -m foo"

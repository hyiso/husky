. "$(dirname -- "$0")/functions.sh"
setup

# Example:
# .git
# sub/pubspec.yaml

mkdir sub
cd sub
dart create -t package . --force 1>/dev/null
dart pub add --dev husky --path=../../husky 1>/dev/null

# Install
cd ..
install
dart run husky install sub/.husky

# Add hook
cd sub
dart run husky add .husky/pre-commit "echo \"pre-commit hook\" && exit 1"

# Test core.hooksPath
expect_hooksPath_to_be "sub/.husky"

# Test pre-commit
git add pubspec.yaml
expect 1 "git commit -m foo"

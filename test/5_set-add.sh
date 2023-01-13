. "$(dirname -- "$0")/functions.sh"
setup
install

f=".husky/pre-commit"

dart run husky install

dart run husky add $f "foo"
grep -m 1 _ $f && grep foo $f && ok

dart run husky add .husky/pre-commit "bar"
grep -m 1 _ $f && grep foo $f && grep bar $f && ok

dart run husky set .husky/pre-commit "baz"
grep -m 1 _ $f && grep foo $f || grep bar $f || grep baz $f && ok


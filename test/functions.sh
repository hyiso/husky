# Exit on error
set -eu

setup() {
  name="$(basename -- $0)"
  testDir="/tmp/husky_test_$name"
  echo
  echo "-------------------"
  echo "+ $name"
  echo "-------------------"
  echo

  # Create test directory
  rm -rf "$testDir"
  mkdir -p "$testDir"
  cd "$testDir"

  # Init git
  git init --quiet
  git config user.email "test@test"
  git config user.name "test"

  # Init pubspec.yaml
  dart create -t package . --force 1>/dev/null
}

install() {
  dart pub add --dev husky --path=../husky 1>/dev/null
}

expect() {
  set +e
  sh -c "$2"
  exitCode="$?"
  set -e
  if [ $exitCode != "$1" ]; then
    error "expect command \"$2\" to exit with code $1 (got $exitCode)"
  fi
}

expect_hooksPath_to_be() {
  readonly hooksPath=`git config core.hooksPath`
  if [ "$hooksPath" != "$1" ]; then
    error "core.hooksPath should be $1, was $hooksPath"
  fi
}

error() {
  echo -e "\e[0;31mERROR:\e[m $1"
  exit 1
}

ok() {
  echo -e "\e[0;32mOK\e[m"
}

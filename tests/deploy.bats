#!/usr/bin/env bats

CONF_DIR="$(cd "$BATS_TEST_DIRNAME/fixtures/basic" && pwd)"

setup() {
  TEST_HOME=$(mktemp -d)
  export DEPLOY_TARGET="$TEST_HOME"
}

teardown() {
  rm -rf "$TEST_HOME"
}

run_deploy() {
  (cd "$CONF_DIR" && ./deploy.sh "$@")
}

@test "file is symlinked into target" {
  run_deploy deploy
  [ -L "$TEST_HOME/.bashrc" ]
}

@test "symlink points to source file" {
  run_deploy deploy
  [ "$(readlink "$TEST_HOME/.bashrc")" = "$CONF_DIR/.bashrc" ]
}

@test "existing file is backed up before symlinking" {
  echo "old" > "$TEST_HOME/.bashrc"
  run_deploy deploy
  [ -L "$TEST_HOME/.bashrc" ]
  bak=$(ls "$TEST_HOME"/.bashrc.bak-* 2>/dev/null | head -1)
  [ -n "$bak" ]
  [ "$(cat "$bak")" = "old" ]
}

@test "equal symlink is skipped on re-deploy (idempotent)" {
  run_deploy deploy
  run_deploy deploy
  count=$(ls "$TEST_HOME"/.bashrc.bak-* 2>/dev/null | wc -l)
  [ "$count" -eq 0 ]
}

@test "overlay-directory recurses instead of linking the directory" {
  run_deploy deploy
  [ ! -L "$TEST_HOME/bin" ]
  [ -d "$TEST_HOME/bin" ]
}

@test "files inside overlay directory are symlinked" {
  run_deploy deploy
  [ -L "$TEST_HOME/bin/some-script" ]
}

@test "ignorefiles entries are not deployed" {
  run_deploy deploy
  [ ! -e "$TEST_HOME/ignorefiles" ]
  [ ! -e "$TEST_HOME/deploy.sh" ]
}

@test "ignorefiles matches by filename, so entries are skipped at any depth" {
  # 'skip-me' is listed in ignorefiles by bare filename (not full path).
  # deploy.sh checks only the basename, so it applies at every recursion depth.
  run_deploy deploy
  [ ! -e "$TEST_HOME/skip-me" ]
  [ ! -e "$TEST_HOME/bin/skip-me" ]
}

@test "dryrun makes no changes" {
  run_deploy dryrun
  [ ! -e "$TEST_HOME/.bashrc" ]
}

@test "test action deploys into TARGET/test subdir" {
  run_deploy test
  [ -L "$TEST_HOME/test/.bashrc" ]
  [ ! -e "$TEST_HOME/.bashrc" ]
}

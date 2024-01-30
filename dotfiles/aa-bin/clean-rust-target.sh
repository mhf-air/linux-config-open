#!/usr/bin/env bash

# set -o xtrace
set -o errexit
set -o pipefail
readonly ARGS="$@"
readonly ARGS_COUNT="$#"
println() {
  printf "$@\n"
}
# ================================================================================

# GOAL: regularly(daily perhaps) clean target directories in rust projects, because they soon occupy tens of GBs of disk space
# NOTE: have to use full path for commands, otherwise might be not found in crontab
main() {
	find ~/rust -depth -maxdepth 4 -name target -exec bash -c "cd {}/.. && [ -e 'Cargo.lock' ] && ~/.cargo/bin/cargo clean" \;
}

main

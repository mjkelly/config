#!/bin/bash
# -----------------------------------------------------------------
# deploy.sh -- Deploys the files in the configuration directory.
# Copyright 2012 Michael Kelly (michael@michaelkelly.org)
#
# This program is released under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# Tue Jan 17 05:45:31 EST 2012
# -----------------------------------------------------------------

# File used to mark directories we should recurse into.
MAGIC_OVERLAY_FILE='overlay-directory'

# So we don't copy this script.
OFFICIAL_NAME="$(basename $0)"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

PACKAGE_FILE="initial_install_packages"

# -----------------------------------------------------------------

# Deploys all the files in the given directory. Tries to skip this script and
# other magic files.
function deploy_dir() {
  local target=$1
  local path=$2
  echo "DIR: $path"

  if [[ (! -d "$target") && "$MODE" == "real" ]]; then
    mkdir -- "$target"
  fi

  local files=($path/.* $path/*)
  for f in "${files[@]}"; do
    # We don't copy a specific list of files.
    if [[ "$f" == "$CONF_DIR/README" || "$f" == "$CONF_DIR/$OFFICIAL_NAME" || "$f" == "$CONF_DIR/$PACKAGE_FILE" || "$f" == "$CONF_DIR/.git" ]]; then
      echo "SKIP: $f"
      continue
    fi

    local base_f="$(basename $f)"
    if [[ "$base_f" == "." || "$base_f" == ".." || "$base_f" == "$MAGIC_OVERLAY_FILE" ]]; then
      echo "SKIP: $f"
      continue
    fi

    # Recurse into overlay directories. Otherwise, treat directories the same as
    # files.
    if [[ -d "$f" && -f "$f/$MAGIC_OVERLAY_FILE" ]]; then
      deploy_dir "$target/$base_f" "$f"
    else
      deploy_file "$target" "$f"
    fi
  done
}

# Deploys a single file, moving any existing file out of the way if necessary.
function deploy_file() {
  local target=$1
  local file=$2
  local base_file="$(basename $file)"
  local dest="$target/$base_file"
  local dest_backup="$target/$base_file.bak-$TIMESTAMP"

  echo "FILE: $file --> $dest"
  if [[ "$MODE" == "real" ]]; then
    if [[ -e "$dest" ]]; then
      mv -- "$dest" "$dest_backup"
    fi
    ln -sf -- "$file" "$dest"
  fi
}

function install_packages() {
  local package_list=$1
  local packages="$(grep -E -v '^\s*#' $package_list)"
  local cmd="sudo aptitude"
  if [[ "$MODE" != "real" ]]; then
    cmd="echo Would run: $cmd"
  fi
  $cmd install $packages
}

# -----------------------------------------------------------------

ACTION=$1
CONF_DIR="$PWD"

if [[ "$ACTION" == "real" ]]; then
  TARGET_DIR="$HOME"
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [[ "$ACTION" == "test" ]]; then
  TARGET_DIR="$HOME/test"
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [[ "$ACTION" == "dry" ]]; then
  echo
  echo "*** Dry-run mode. Run '$0 real' to run for real. ***"
  echo
  TARGET_DIR="$HOME"
  MODE="test"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [[ "$ACTION" == "dry-packages" ]]; then
  echo
  echo "*** Dry-run mode. Run '$0 packages' to run for real. ***"
  echo
  MODE="test"
  install_packages "$CONF_DIR/$PACKAGE_FILE"
elif [[ "$ACTION" == "packages" ]]; then
  MODE="real"
  install_packages "$CONF_DIR/$PACKAGE_FILE"
else
  echo "USAGE: $0 test|real|dry|packages|dry-packages"
  exit 2
fi

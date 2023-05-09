#!/bin/sh
# -----------------------------------------------------------------
# deploy.sh -- Deploys the files in the configuration directory.
# 
# Copyright (c) 2023 Michael J. Kelly <m@michaelkelly.org>.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     1. Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.
#     2. Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#     3. Neither the name of the copyright holder nor the names of its
#        contributors may be used to endorse or promote products derived from this
#        software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Tested with dash 0.5.7 and public domain ksh 5.2.14.
#
# Sun May  7 11:23:40 PM PDT 2023
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
deploy_dir () {
  local target=$1
  local path=$2
  echo "DIR: $path"

  if [ ! -d "$target" -a "$MODE" = "real" ]; then
    mkdir -- "$target"
  fi

  ls -a $path | while read base_f; do
    f="$path/$base_f"
    # We don't copy a specific list of files.
    if grep -q -- "^$base_f\$" "$CONF_DIR/deploy.ignorefiles"; then
      echo "SKIP: $f"
      continue
    fi

    # Don't even mention skipping "." and "..".
    if [ "$base_f" = "." -o "$base_f" = ".." ]; then
      continue
    fi

    # Recurse into overlay directories. Otherwise, treat directories the same as
    # files.
    if [ -d "$f" -a -f "$f/$MAGIC_OVERLAY_FILE" ]; then
      deploy_dir "$target/$base_f" "$f"
    else
      deploy_file "$target" "$f"
    fi
  done
}

# Deploys a single file, moving any existing file out of the way if necessary.
deploy_file () {
  local target="$1"
  local file="$2"
  local base_file="$(basename $file)"
  local dest="$target/$base_file"
  local dest_backup="$target/$base_file.bak-$TIMESTAMP"

  echo "LINK: $file --> $dest"
  if [ "$MODE" = "real" ]; then
    if [ -e "$dest" ]; then
      mv -- "$dest" "$dest_backup"
    fi
    ln -sf -- "$file" "$dest"
  fi
}

install_packages () {
  local package_list=$1
  local packages="$(grep -E -v '^\s*#' $package_list)"
  local cmd="sudo apt-get"
  if [ "$MODE" != "real" ]; then
    cmd="echo Would run: $cmd"
  fi
  $cmd install -y $packages
}

# -----------------------------------------------------------------

ACTION=$1
CONF_DIR="$PWD"

if [ "$ACTION" = "config" ]; then
  TARGET_DIR="$HOME"
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [ "$ACTION" = "test-config" ]; then
  TARGET_DIR="$HOME/test"
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [ "$ACTION" = "dry-config" ]; then
  echo
  echo "*** Dry-run mode. Run '$0 config' to run for real. ***"
  echo
  TARGET_DIR="$HOME"
  MODE="test"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [ "$ACTION" = "dry-packages" ]; then
  echo
  echo "*** Dry-run mode. Run '$0 packages' to run for real. ***"
  echo
  MODE="test"
  install_packages "$CONF_DIR/$PACKAGE_FILE"
elif [ "$ACTION" = "packages" ]; then
  MODE="real"
  install_packages "$CONF_DIR/$PACKAGE_FILE"
else
  echo "USAGE: $0 test-config|config|dry-config|packages|dry-packages"
  exit 2
fi

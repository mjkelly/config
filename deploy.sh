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
# Tested with dash 0.5.11.
#
# Thu Jul 13 12:10:10 AM EDT 2023
# -----------------------------------------------------------------

# File used to mark directories we should recurse into.
MAGIC_OVERLAY_FILE='overlay-directory'
# Where we look for names of files to skip
IGNOREFILES="ignorefiles"
# Timestamp for this run
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# -----------------------------------------------------------------

# Deploys all the files in the given directory. Tries to skip this script and
# other magic files.
deploy_dir () {
  local target=$1
  local path=$2
  echo "# DIR: $path"

  if [ ! -d "$target" -a "$MODE" = "real" ]; then
    mkdir -- "$target"
  fi

  ls -a $path | while read base_f; do
    f="$path/$base_f"
    # We don't copy a specific list of files.
    if grep -q -- "^$base_f\$" "$CONF_DIR/$IGNOREFILES"; then
      echo "# SKIP: $f"
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

  if [ "$MODE" = "real" ]; then
    if [ -e "$dest" ]; then
      # Don't make backups of links if we don't have to
      if [ -h "$dest" -a "$(readlink "$dest")" = "$file" ]; then
        echo "# SKIP EQUAL SYMLINK: $file -> $dest"
        return
      fi
      maybe_mv -- "$dest" "$dest_backup"
    fi
    maybe_ln -sf -- "$file" "$dest"
  fi
}

maybe_ln () {
  echo ln "$@"
  if [ "$MODE" = "real" ]; then
    ln "$@"
  fi
}

maybe_mv () {
  echo mv "$@"
  if [ "$MODE" = "real" ]; then
    mv "$@"
  fi
}

# -----------------------------------------------------------------

ACTION=$1
CONF_DIR="$PWD"

if [ "$ACTION" = "deploy" ]; then
  TARGET_DIR="$HOME"
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [ "$ACTION" = "test" ]; then
  TARGET_DIR="$HOME/test"
  echo
  echo "*** Test-run mode. Deploying to ${TARGET_DIR}. ***"
  echo
  MODE="real"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
elif [ "$ACTION" = "dryrun" ]; then
  echo
  echo "*** Dry-run mode. Run '$0 config' to run for real. ***"
  echo
  TARGET_DIR="$HOME"
  MODE="test"
  deploy_dir "$TARGET_DIR" "$CONF_DIR"
else
  echo "USAGE: $0 dryrun|test|deploy"
  exit 2
fi

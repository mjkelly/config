#!/usr/bin/env python3
# -----------------------------------------------------------------
# mved.py -- Renames files in the current directory through a text editor.
# Copyright 2007 Michael Kelly (m@michaelkelly.org), Hunter Freyer
# (yt@hjfreyer.com).
#
# This program is released under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# -----------------------------------------------------------------

import sys
import os
import subprocess
import tempfile
import argparse


def sorted_file_list(directory, include_hidden=False):
    '''Get a sorted list of the files in the given directory.

    Args:
      include_hidden: if true, include hidden (dot) files.
    '''
    files = os.listdir(directory)
    if not include_hidden:
        files = [f for f in files if not f.startswith('.')]
    files.sort()
    return files


def get_editor():
    '''Try to determine the user's preferred editor'''
    return os.getenv('EDITOR', os.getenv('VISUAL', 'vi'))


def update_files(old_files, new_files, directory, dry_run=True):
    renames, deletes = 0, 0
    for i, new_file in enumerate(new_files):
        old_file = old_files[i]
        if old_files[i] != new_file:
            if new_file != '':
                renames += 1
                if dry_run:
                    print(f'  mv {old_file} {new_file}')
                else:
                    os.rename(os.path.join(directory, old_file),
                              os.path.join(directory, new_file))
            else:
                deletes += 1
                if dry_run:
                    print(f'  rm {old_file}')
                else:
                    os.unlink(os.path.join(directory, old_file))
    return renames, deletes


def confirm(msg):
    '''Prompt the user with message to which they can reply 'y' or 'n'.'''
    sys.stdout.write(msg + ' [y/N] ')
    sys.stdout.flush()
    response = sys.stdin.readline().strip().lower()
    return response == 'y' or response == 'yes'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-a',
        default=False,
        action='store_true',
        dest='list_all',
        help='List all files (including dotfiles; excluding "." and "..").')
    parser.add_argument(
        'directory',
        nargs='?',
        default=None,
        help='Directory to rename files in (default: current directory).')
    args = parser.parse_args()

    cwd = os.path.abspath(args.directory) if args.directory else os.getcwd()
    files = sorted_file_list(cwd, args.list_all)
    for f in files:
        if '\n' in f or '\r' in f:
            print(f'ERROR: filename contains a newline or carriage return -- we do not support this: {f!r}')
            sys.exit(2)
    editor = get_editor()

    tmpfd, tmpname = tempfile.mkstemp()
    try:
        for f in files:
            os.write(tmpfd, (f + '\n').encode())
        os.close(tmpfd)

        result = subprocess.run([editor, tmpname])
        if result.returncode != 0:
            print(f'{editor} exited with nonzero status ({result.returncode}). Aborting.')
            sys.exit(2)

        with open(tmpname, 'r') as tmp:
            new_files = tmp.readlines()
            if len(new_files) != len(files):
                print(
                    "ERROR: You added or deleted a line. Don't do that. Use blank "
                    'lines to delete files.')
                sys.exit(2)
        new_files = [f.rstrip('\n\r') for f in new_files]
    finally:
        os.unlink(tmpname)

    print(f'In {cwd}:')
    renames, deletes = update_files(files, new_files, cwd, dry_run=True)
    if renames + deletes == 0:
        print('No changes.')
        sys.exit(0)
    proceed = confirm(
        f'Will rename {renames} and delete {deletes} files. Proceed?')
    if not proceed:
        print('No. Aborting.')
        sys.exit(1)
    renames, deletes = update_files(files, new_files, cwd, dry_run=False)
    print(f'Renamed {renames} and deleted {deletes} files.')


if __name__ == '__main__':
    main()

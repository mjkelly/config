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


def update_files(old_files, new_files, dry_run=True):
    renames, deletes = 0, 0
    for i, new_file in enumerate(new_files):
        old_file = old_files[i]
        if old_files[i] != new_file:
            if new_file != '':
                renames += 1
                if dry_run:
                    print('  mv %s %s' % (old_file, new_file))
                else:
                    os.rename(old_file, new_file)
            else:
                deletes += 1
                if dry_run:
                    print('  rm %s' % old_file)
                else:
                    os.unlink(old_file)
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
    args = parser.parse_args()

    cwd = os.getcwd()
    files = sorted_file_list(cwd, args.list_all)
    for f in files:
        if '\n' in f:
            print("ERROR: filename contains a newline -- we do not support this: %r" % f)
            sys.exit(2)
    editor = get_editor()

    tmpfd, tmpname = tempfile.mkstemp()
    try:
        for f in files:
            os.write(tmpfd, (f + '\n').encode())
        os.close(tmpfd)

        result = subprocess.run([editor, tmpname])
        if result.returncode != 0:
            print('%s exited with nonzero status (%d). Aborting.' % (editor, result.returncode))
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

    renames, deletes = update_files(files, new_files, dry_run=True)
    if renames + deletes == 0:
        print('No changes.')
        sys.exit(0)
    proceed = confirm(
        'Will rename %d and delete %d files. Proceed? ' % (renames, deletes))
    if not proceed:
        print('No. Aborting.')
        sys.exit(1)
    renames, deletes = update_files(files, new_files, dry_run=False)
    print('Renamed %d and deleted %d files.' % (renames, deletes))


if __name__ == '__main__':
    main()

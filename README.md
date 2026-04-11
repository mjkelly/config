# config

[![builds.sr.ht status](https://builds.sr.ht/~mkelly/config/commits/master.svg)](https://builds.sr.ht/~mkelly/config/commits/master?)

_The canonical location of this repo is: <https://git.sr.ht/~mkelly/config>.
Other locations are mirrors._

These are my personal configs, for setting up new machines. I use these configs
both for laptops and servers.

# Usage

`deploy.sh` is a convenient, though crude, deployment script. Run `./deploy.sh`
to see usage options.

# Conventions

- `overlay-directory`: the presence of this file in a directory means
  that that won't be symlinked to the destination directly. Instead, we'll
  symlink each file inside into the destination directory. (We will create the
  destination directory if necessary.)
- `ignorefiles`: This file has the names of files we will skip entirely (like
  this script). Entries are bare filenames, not paths — an entry applies at
  every directory depth, so `foo` would skip both a top-level `foo` and a
  nested `bin/foo`.

# Testing

`deploy.sh` has a test suite in `tests/`. It requires
[bats](https://github.com/bats-core/bats-core), which is not included and must
be installed separately (e.g. `sudo dnf install bats` or `brew install
bats-core`).

```sh
bats tests/
```

(This is 90% an exercie in learning how to test bash scripts, and 10% so I can
freely update `deploy.sh` without fear of breaking it.)

# License

All original work in this repository is covered by the BSD 3-clause license
(see LICENSE.txt), unless otherwise specified in the file itself. Third-party
code has LICENSE files specifying its license.

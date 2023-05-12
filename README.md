# config

[![builds.sr.ht status](https://builds.sr.ht/~mkelly/config/commits/master.svg)](https://builds.sr.ht/~mkelly/config/commits/master?)

_The canonical location of this repo is: <https://git.sr.ht/~mkelly/config>.
Other locations are mirrors._

My personal configs, for setting up new machines. I use these configs both for
laptops and servers.

deploy.sh is a convenient, though crude, deployment script. (I could probably
use the `dotfiles` program for this now, but I didn't know about `dotfiles`
then and this repo appears to predate it.)

Some configs reference excluded files ending in `.localonly`. These contain
authentication information, etc, and are .gitignore'd. They must be manually
added.

Some configs contain `$USERNAME$`, `$PASSWORD$`, and other pseudo-variables. You
must replace those manually. My local username is `mkelly`, and that is
floating around as well.

`initial_install_packages` contains a list of packages to be installed
(`deploy.sh` uses `apt` to install them). Lines beginning with `#` are
comments.

# License

All original work in this repository is covered by the BSD 3-clause license
(see LICENSE.txt), unless otherwise specified in the file itself. Third-party
code has LICENSE files specifying its license.

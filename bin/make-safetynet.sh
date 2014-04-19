#!/bin/bash
# Copies vital account files.
#
# The resulting archive should contain only private data protected by the GPG
# private key. Note that the (encrypted) private key is included! The GPG
# passphrase is the only thing protecting this bundle. This is intended for
# last-ditch recovery from data loss, etc.
#
# Sat Apr 12 16:11:31 EDT 2014
# Michael Kelly. Public domain.

host="$(hostname -s)"
now="$(date '+%F-%H-%M-%S')"
safety_prefix="safetynet-${host}"
safety="${safety_prefix}-${now}"
safety_archive="${safety}.tgz"
backup_dir=~/bak

die() {
        echo >&2 FAILED
        exit 1
}


if [ ! -d "${backup_dir}" ]; then
        echo >&2 "Backup dir ${backup_dir} does not exist."
        die
fi
cd "${backup_dir}"

mkdir "${safety}"

# This is the highly specific part.
cp -r ~/.gnupg "${safety}/dot-gnupg" || die
cp ~/txt/pass/*.gpg "${safety}" || die

cat > "${safety}/README" <<_README_
Recovery files from $HOSTNAME, generated on $(date).

The script that created these files is included.

Good luck.
_README_
if [ "$?" != "0" ]; then die; fi

cp $0 "${safety}/" || die

echo "=== New archive is ${safety_archive} ==="
tar -cvzf "${safety_archive}" "${safety}" && rm -r "${safety}"
if [ "$?" != "0" ]; then die; fi

# Also clean up old files more than 90 days old.
echo "=== Old archive to remove ==="
find . -mtime +90 -name "${safety_prefix}*" -print -exec rm {} \;

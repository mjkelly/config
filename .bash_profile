if [ -e ~/.bashrc ]; then
	. ~/.bashrc
fi

keychain -q --timeout 1440 ~/.ssh/*-key
. ~/.keychain/$HOSTNAME-sh

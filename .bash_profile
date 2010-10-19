if [ -e ~/.bashrc ]; then
	. ~/.bashrc
fi

keychain ~/.ssh/*-key
. ~/.keychain/$HOSTNAME-sh

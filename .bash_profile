if [ -e ~/.bashrc ]; then
	. ~/.bashrc

  kc
fi


#if which keychain >/dev/null 2>&1; then
  #keychain -q --timeout 1440 ~/.ssh/*-key
  #. ~/.keychain/$HOSTNAME-sh
#fi

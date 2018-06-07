umask 002

if [ -d "$HOME/opt/bin" ]; then
	PATH="$HOME/opt/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.nvm" ]; then
  . $HOME/.nvm/nvm.sh
fi

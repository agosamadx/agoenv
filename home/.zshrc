if [ $TERM = "xterm-256color" ]; then
	export LANG=ja_JP.UTF-8
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# alias
alias sudo='LANG=C sudo'
alias ls='ls --color=auto'

# zsh #
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -Uz compinit;
compinit -u

autoload -Uz colors
colors

# emacsキーバインド
bindkey -e

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '(%R/.%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%R/.%s)-[%b|%a]'
zstyle ':vcs_info:(svn):*' branchformat '%b:r%r'

autoload -Uz add-zsh-hook
function _update_vcs_info_msg() {
	psvar=()
	LANG=C vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

# 補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# prompt
PROMPT="%n@%m:%~%% "
RPROMPT="%1(v|%F{green}%1v%f|)"

# timeout
TMOUT=604800

# history
HISTFILE=~/.zsh_history
HISTSIZE=65535
SAVEHIST=65535
# ignore duplication command history list
setopt hist_ignore_dups
# share command history data
setopt share_history

# ^Dでログアウトしないようにする。
setopt ignore_eof

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# TAB で順に補完候補を切り替える
setopt auto_menu

# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup

# ログアウト時にバックグラウンドジョブを確認しない
setopt no_checkjobs

# 補完時に勝手に/をつけない
setopt no_auto_param_slash

# rm 時に聞くな
setopt rm_star_silent

# 補完リストに色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

# ディレクトリ名でcd
setopt auto_cd

# google で検索できる
function google() {
   local str opt
   if [ $# != 0 ]; then
       for i in $*; do
           str="$str+$i"
       done
       str=`echo $str | sed 's/^\+//'`
       opt='search?num=50&hl=ja&lr=lang_ja'
       opt="${opt}&q=${str}"
    fi
    w3m http://www.google.co.jp/$opt
}

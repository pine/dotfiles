# ---------------------------------------------------------
# .zshrc
# ---------------------------------------------------------

# ---------------------------------------------------------
# *** 補完 ***
# ---------------------------------------------------------

# 補完を有効にする
autoload -U compinit
compinit

# エイリアスでも補完機能を有効
setopt complete_aliases

# カーソル位置で補完
setopt complete_in_word

# コマンドライン引数の = 以降も補完する (-prefix=〜等)
setopt magic_equal_subst

# sudo 付きでも補完する
zstyle ':completion:*:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# * 展開に失敗してもエラー表示しない
setopt nonomatch

# ---------------------------------------------------------
# *** プロンプト ***
# ---------------------------------------------------------

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
#
# # 表示フォーマットの指定
# # %b ブランチ情報
# # %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

char_hostname () {
	hostname=`hostname -f | cut -f 1 -d .`
	hostname_f=`hostname -f`

	if [[ "$hostname_f" =~ "$USER\.dev\.[a-z]+\.local" ]] then
		echo "ruri"
	elif [[ "$hostname" =~ "[a-z]{2}pc222" ]] then
		echo "miuna"
	else
		echo $hostname
	fi
}

precmd () {
	psvar=()
	LANG=en_US.UTF-8 vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
	psvar[2]=`char_hostname`
}

# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
PROMPT="[%n@%2v %1~] %(!.#.$) "
RPROMPT="%1(v|%F{green}%1v%f|)"

# ---------------------------------------------------------
# *** ディレクトリ ***
# ---------------------------------------------------------

setopt auto_cd           # ディレクトリ名のみで移動
setopt auto_pushd        # ディレクトリ移動時にスタックに積む
setopt pushd_ignore_dups # 同じディレクトリは追加しない
setopt pushd_silent      # ディレクトリスタックの内容を表示しない

# cd 可能なディレクトリ
cdpath=(
	~/project(N-/)
)


# ---------------------------------------------------------
# *** ヒストリ ***
# ---------------------------------------------------------

# ヒストリを拡張形式で保存
setopt extended_history

# ヒストリを複数端末で共有する
setopt share_history

# 履歴を上書きではなく追加する
setopt append_history

HISTFILE=~/.zsh_history # ヒストリを保存するファイル
HISTSIZE=10000          # メモリに記憶しておくヒストリの最大数
SAVEHIST=10000          # ファイルへ保存するヒストリの最大数


# show_buffer_stack() {
#   POSTDISPLAY="
# stack: $LBUFFER"
#   zle push-line-or-edit
# }
# zle -N show_buffer_stack
# setopt noflowcontrol
# bindkey '^Q' show_buffer_stack


# ---------------------------------------------------------
# *** コマンドエイリアス ***
# ---------------------------------------------------------

# ls
case ${OSTYPE} in
	darwin*)
		alias ls='ls -G'
		;;
	linux*)
		alias ls='ls --color=tty'
		;;
esac

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# screen
alias s='if [[ ! $TERM == screen* ]]; then; screen -xRU; fi'
alias ns="screen -c \"cd \`pwd\`\"" # 新規スクリーン

# dir
if ! type -p dir > /dev/null 2>&1; then
	alias dir=ls # 誤発動防止
fi

# diff
alias diff="diff --strip-trailing-cr" # 改行コード無視

alias soz='source ~/.zshrc'

alias tsc='tsc -target ES5 --module "commonjs"'

alias httpd='python -m SimpleHTTPServer'

# タイプミス防止
alias cls="clear"
alias apitude="aptitude"
alias vi="vim"

# Visual Studio Code
case ${OSTYPE} in
	darwin*)
		code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}
		;;
esac

# ---------------------------------------------------------
# *** PATH ***
# ---------------------------------------------------------

# 重複パスを登録しない
typeset -U path cdpath fpath manpath

typeset -xT PKG_CONFIG_PATH pkg_config_path
typeset -U pkg_config_path

# anyenv
if [[ -d "$HOME/.anyenv" ]] then
	path=($HOME/.anyenv/bin $path)
	eval "$(anyenv init -)"
fi

# nodebrew
if [[ ! -d "$HOME/.anyenv/envs/ndenv" ]] then
	if [[ -d "$HOME/.nodebrew" ]] then
		path=($HOME/.nodebrew/current/bin $path)
	fi
fi

# crystalbrew
# if [[ -d "$HOME/.crystalbrew" ]] then
# 	path=($HOME/.crystalbrew/current/bin $path)
# fi

# phpenv
if [[ -d "$HOME/.phpenv" ]] then
	export PATH="$HOME/.phpenv/bin:$PATH"
	eval "$(phpenv init -)"
fi

# direnv
if type -p direnv > /dev/null 2>&1; then
	eval "$(direnv hook zsh)"
fi

# rsvm
if [[ -s "$HOME/.rsvm/rsvm.sh" ]] then
	. "$HOME/.rsvm/rsvm.sh"
fi

# Android Studio
if [[ -d "$HOME/Library/Android/sdk" ]] then
	export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

path=(
	$ANDROID_HOME/tools(N-/)
	$ANDROID_HOME/platform-tools(N-/)
	$path
)

# その他コマンド
path=(
	/usr/local/redis/bin(N-/)
	/usr/local/app/vim/bin(N-/)
	/usr/local/bin(N-/)
	$HOME/bin(N-/)
	$HOME/bin/*/bin(N-/)

	$path

	/usr/local/*/bin(N-/)
	)

pkg_config_path=(
	/opt/X11/lib/pkgconfig(N-/)
	$pkg_config_path
)

# ---------------------------------------------------------
# *** その他 ***
# ---------------------------------------------------------

# merge 時にエディタを自動的に立ち上げない
export GIT_MERGE_AUTOEDIT=no

if type -p lv >/dev/null 2>&1; then
	export GIT_PAGER="lv -c"
fi

if type -p vim > /dev/null 2>&1; then
	export EDITOR=vim
fi

# 言語設定
case ${OSTYPE} in
	linux*)
		export LC_ALL='en_US.UTF-8'
		;;
esac

# ---------------------------------------------------------
# *** 実行 ***
# ---------------------------------------------------------

# travis
[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ~/.zshrc.local
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# ~/.zsh.d/*.zsh
if [[ -d "$HOME/.zsh.d" ]] then
	for f in ~/.zsh.d/*; do source "$f"; done
fi

# screen を起動
if [[ $TERM != 'screen' ]] then
#	screen -xRU
fi

# vim: se noet ts=4 sw=4 sts=0 ft=zsh :


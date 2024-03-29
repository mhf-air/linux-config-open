# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# color constants
black='\033[0;30m'
darkgray='\033[1;30m'
blue='\033[0;34m'
darkblue='\033[1;34m'
green='\033[0;32m'
darkgreen='\033[1;32m'
cyan='\033[0;36m'
darkcyan='\033[1;36m'
red='\033[0;31m'
darkred='\033[1;31m'
purple='\033[0;35m'
darkpurple='\033[1;35m'
brown='\033[0;33m'
yellow='\033[1;33m'
lightgray='\033[0;37m'
white='\033[1;37m'
nocolor='\033[0m'

printf '\033]12;purple\007'

# If not running interactively, don't do anything
case $- in
		*i*) ;;
			*) return;;
esac

# prevent exiting terminal(mainly tmux) with Ctrl + D
set -o ignoreeof

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
		debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
		xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
		if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
		else
	color_prompt=
		fi
fi

_git-existed() {
	local str arr
	str=$(ls -a)
	set -f
	arr=(${str})
	for branch in "${arr[@]}"; do
		if [[ "$branch" == ".git" ]]; then
			return 0
		fi
	done

	return 1
}

_get-branch() {
	if ! _git-existed ; then
		return
	fi
	local b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ "$b" = HEAD ] ; then
		return
	fi
	local currentBranch="<$b>"
	echo $currentBranch
}

if [ "$color_prompt" = yes ]; then
		PS0='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
		#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
		# PS1="${cyan}\w${green}\$ ${nocolor}"

		PS1="${cyan}\w${brown}"'$(_get-branch)'"${green}\$ ${nocolor}"
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
*)
		;;
esac

# alias definitions.
if [ -f ~/.bash_aliases ]; then
		. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if [[ -d ~/.bash_completion.d ]]; then
		. ~/.bash_completion.d/*.bash
fi

# bind 'set show-all-if-ambiguous on'

export EDITOR=/usr/local/bin/vim

if command -v tabs &> /dev/null; then
	tabs 4
fi

# show $PATH
# echo $PATH | tr ":" "\n" | nl

_path="/___impossible_path"
_add-path() {
	_path="$_path:$1"
}
_export-path() {
	if [[ "$PATH" == *"___impossible_path"* ]]; then
		return
	fi
	export PATH="$_path:$PATH"
}

_add-path $HOME/.bin/aa

# go
export GOPATH=$HOME/go
_add-path $GOPATH/bin
export GOROOT=/usr/local/go
_add-path $GOROOT/bin

# rust
export CARGO_HOME=$HOME/.cargo
_add-path $CARGO_HOME/bin

# android
export ANDROID_HOME=$HOME/android/sdk
_add-path $ANDROID_HOME/emulator
_add-path $ANDROID_HOME/tools
_add-path $ANDROID_HOME/platform-tools
export JAVA_HOME=$HOME/android/android-studio/jre
_add-path $JAVA_HOME/bin

# yarn
_add-path $HOME/.yarn/bin

# cuda
export CUDA_HOME=/usr/local/cuda
_add-path $CUDA_HOME/bin
export LD_LIBRARY_PATH=$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# for vulkan to work
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json

# proxy
# export http_proxy=http://127.0.0.1:7777
# export https_proxy=http://127.0.0.1:7777

_exportCommon() {
	local list=("node" "blender" "cmake" "clang")

	for item in "${list[@]}"; do
		_add-path $HOME/.bin/$item
	done
}
_exportCommon

_export-path

# link-to-bin gradle-1.0/bin gradle
link-to-bin() {
	local src="$1"
	local target="$2"
	ln -s $(realpath "$src") ~/.bin/"$target"
}

restart-ss() {
	sudo systemctl restart cow.service
	sudo systemctl restart shadowsocks.service
}

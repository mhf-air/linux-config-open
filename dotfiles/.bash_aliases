shopt -s expand_aliases

# some grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some ls aliases
alias ls='ls --color=auto'
alias ll='ls -AlFsh'
alias la='ls -A'
alias l='ls -CF'

# misc
alias cp='cp -v'
alias mv='mv -v'
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias v='vim'
alias rvim='sudo -E vim'

# pdf转换成txt, 分页符号转换成----------
# in vim, enter ^L using ctrl-v ctrl-l
pdftotext-with-page-break() {
	if [ "$#" -ne 1 ]; then
		echo "enter pdf file name"
		return
	fi

	local path="$1"
	local txtName="/tmp/pdf.txt"

	pdftotext -layout "$path" "$txtName"

	sed -i 's/\f/\n--------------------------------------------------------------------------------\n/' "$txtName"
	echo "see /tmp/pdf.txt"
}

newfile() {
	local path="$1"
	local dir=$(dirname "$path")
	mkdir -p "$dir"
	touch "$path"
}
c() {
	cd "$@"
	l
}
alias ..='c ..'
alias ...='c ../..'

b() {
	local url="$1"
	google-chrome "$url" &> /dev/null
	wmctrl -a tilda
}

alias d="docker"
alias py="python3"
alias conda-base="conda activate base"
alias yarn-global-update="yarn global upgrade-interactive"
alias fe="xdg-open . &> /dev/null && sleep 0.3s && wmctrl -a tilda"

# tmux start cmd
alias tm="tmux \
new -c ~/py/wiki/tf -n server-running -s server-running \; \
split-window -h -c ~/js/work/ufun-new-bc\; \
select-pane -t 1 \; \
new -c ~/rust/third/rust/u -n server -s default\; \
new-window -c ~/py/wiki/tf -n ai -t default\; \
select-pane -t 1 \; \
new-window -c ~/rust/wiki -n rust -t default\; \
select-pane -t 1 \; \
new-window -c ~/js/work/ufun-new-bc -n js -t default\; \
select-pane -t 1 \; \
select-window -t default:1 \; \
"

# split-window -vc ~/go/src/wiki -p 15 -t default \; \
# split-window -hc ~/go/src/wiki -p 50 -t default \; \
alias q-tmux="tmux kill-server"

alias m='make'

alias amamam='xmodmap ~/.xmodmaprc'
alias mamama='setxkbmap -option'
alias setproxy="export http_proxy=http://127.0.0.1:7777; export https_proxy=http://127.0.0.1:7777; echo 'HTTP Proxy on'"
alias unsetproxy="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off'"

#some git basic aliases
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph \
--pretty=format:"%C(red)%h   %C(green)%ad   %C(cyan)%s   %C(dim white)%an%Creset  %C(yellow)%d" \
--date=short'
alias gm='git merge'
alias gmt='git mergetool'
alias gs='git status --ignore-submodules'
alias gg='git add . && git commit -m "s:"'

alias edit-remote-file='sshfs -o idmap=user root@192.168.1.9:/etc /home/mhf/go/src/wiki/remote-server'

#common typos
alias suod='sudo'
alias eixt='exit'
alias vmi='vim'

#---------------------------------- vim -----------------------------------
vv() {
	local session window pane servername str vimcmd

	if [[ -n "$(ps -e | grep tmux)" ]]; then
		session=$(tmux list-sessions | grep attached | cut -d : -f 1)
		window=$(tmux list-windows | grep active | cut -d : -f 1)
		pane=$(tmux list-panes | grep active | cut -d : -f 1)
		servername=$(echo $session$window$pane | tr 'a-z' 'A-Z')
	else
		servername=$(echo "not-in-tmux" | tr 'a-z' 'A-Z')
	fi

	str=$(vim --serverlist | grep "$servername")
	if [[ -n "$str" ]]; then
		if [ -n "$1" ]; then
			#now only support open one file, e.g. v .bashrc
			vimcmd=":cd $PWD<cr>:tabnew<cr>:e $1<cr>"
		else
			vimcmd=":cd $PWD<cr>"
		fi

		vim --servername "$str" --remote-send "$vimcmd"
		fg
	else
		vim --servername "$servername"
	fi
}

#------------------------------ git workflow ------------------------------
git-last-push() {
	local origin=$(git remote)
	local cur=$(git rev-parse --abbrev-ref HEAD)
	local commit=$(git rev-parse "${origin}/${cur}")
	git reset "$commit"
}

git-clean() {
	echo "***** before *****"
	git count-objects -vH
	echo

	git reflog expire --all --expire=now
	git gc --prune=now --aggressive

	echo
	echo "***** after *****"
	git count-objects -vH
}

#---------------------------------- man -----------------------------------
man() {
	LESS_TERMCAP_mb=$'\e'"[1;31m" \
	LESS_TERMCAP_md=$'\e'"[1;36m" \
	LESS_TERMCAP_me=$'\e'"[0m" \
	LESS_TERMCAP_se=$'\e'"[0m" \
	LESS_TERMCAP_so=$'\e'"[1;40;92m" \
	LESS_TERMCAP_ue=$'\e'"[0m" \
	LESS_TERMCAP_us=$'\e'"[1;32m" \
	command man "$@"
}

r() {
	if [[ -x ".r" ]]; then
		./.r "$@"
	fi
}

#---------------------------- to be continued -----------------------------

# usage:
#   _progress(num_done, sleep_period = 0.1)
# TODO
#   learn how to import other shell scripts
_progress() {
	local num="$1"
	local default_sleep_period=0.1
	local sleep_period="${2:-$default_sleep_period}"

	local num_total=50
	local num_done=$((num / 2))
	local num_undone=$((num_total - num_done))

	local done_bar="##################################################"
	local undone_bar=".................................................."

	# color
	local green='\033[0;32m'
	local nocolor='\033[0m'

	printf "[${green}${done_bar:0:${num_done}}${nocolor}${undone_bar:0:${num_undone}}] (%d%%)\r" "${num}"

	sleep "$sleep_period"
}

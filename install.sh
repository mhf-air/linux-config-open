#!/usr/bin/env bash

# set -o xtrace
set -o errexit
set -o pipefail
readonly ARGS="$@"
readonly ARGS_COUNT="$#"
println() {
	printf "$@\n"
}
# --------------------------------------------------------------------------------

# must run ./install.sh in linux-config/

# keyboard shortcut
#   open Tweaks -> Extensions -> Workspace grid -> setting: 2 x 2
#   open Settings -> Devices -> Keyboard
#     move to the bottom, click + button, enter
#       cycle workspace v
#       /home/mhf/.bin/aa/cycle-workspace.sh v
#       F2
#
#       cycle workspace h
#       /home/mhf/.bin/aa/cycle-workspace.sh h
#       F3

# open chrome -> stylus extension option -> import conf/stylus-some-date.json

# install googlepinyin
# Settings -> Region & Language -> Manage Installed Languages
# reboot
# change fcitx settings to have ,. for next page and Shift for second and third candidates

# edit crontab -e
# add
# 0 13 * * * ~/.bin/aa/clean-rust-target.sh >> /tmp/clean-rust-target.log 2>&1

mkHomeDir() {
	local cwd=$(pwd)
	cd ~

	mkdir -p \
		.config/autostart .config/tilda \
		.bin/aa .Desktop \
		.vim/autoload \
		downloads c \
		rust/third rust/wiki \
		py/wiki/tf \
		go/bin go/pkg go/src/wiki go/src/nice \
		js/work \
		android/project android/sdk \
		software/node

	cd $cwd
}

cpDotFile() {
	local cwd=$(pwd)
	cd dotfiles

	cp .bash_aliases .bashrc .gitconfig .inputrc .tmux.conf .vimrc .xmodmaprc .orig-xmodmaprc .tern-project ~
	cp -r .bash_completion.d ~
	. ~/.bashrc

	cp .ycm_extra_conf.py ~/c

	cp .rustfmt.toml ~/rust

	cp plug.vim ~/.vim/autoload

	# hide icons on the desktop
	cp user-dirs.dirs ~/.config/

	# /etc/xdg/autostart is the place to add autostart script too
	cp autostart/* ~/.config/autostart
	cp tilda/* ~/.config/tilda

	cp aa-bin/* ~/.bin/aa

	cd $cwd
}

installUtility() {
	# sudo add-apt-repository ppa:git-core/ppa

	sudo apt update
	sudo apt install \
		vim tilda git htop tree silversearcher-ag unrar \
		curl wget make gcc cmake httpie gnome-tweak-tool chrome-gnome-shell \
		python3-pip pylint3 clang-format exuberant-ctags \
		wmctrl libxtst-dev \
		shadowsocks-libev \
		# texlive-latex-extra texlive-lang-chinese texlive-luatex texlive-xetex latexmk zathura \
		# fcitx-bin fcitx-googlepinyin fcitx-ui-qimpanel \

	# sudo apt remove fcitx-ui-classic
}

compileTmux() {
	local cwd=$(pwd)
	cd /tmp

	sudo apt remove tmux
	sudo apt install \
	 libncurses5-dev libncursesw5-dev

	local libeventVersion=2.1.8-stable
	local libevent=libevent-${libeventVersion}.tar.gz
	wget https://github.com/libevent/libevent/releases/download/release-${libeventVersion}/$libevent
	tar -xzf $libevent
	cd libevent-${libeventVersion}
	./configure && make && sudo make install
	cd ..

	local tmuxVersion=3.0
	local tmux=tmux-${tmuxVersion}.tar.gz
	wget https://github.com/tmux/tmux/releases/download/${tmuxVersion}/$tmux
	tar -xzf $tmux
	cd tmux-${tmuxVersion}
	./configure --enable-static && make && sudo make install

	cd $cwd
}

compileVim() {
	sudo apt install \
		libncurses5-dev libgtk2.0-dev libatk1.0-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev \
		python-dev python3-dev ruby-dev libperl-dev

	local cwd=$(pwd)

	# wget https://codeload.github.com/vim/vim/zip/master -O /tmp/vim-master.zip
	# unzip /tmp/vim-master.zip -d ~/software
	# cd ~/software/vim-master

	# consider cloning from gitee if github is slow, gitee account info: qq and j
	# cd ~/software
	# git clone https://github.com/vim/vim.git
	# cd vim

	make distclean
	./configure --with-features=huge \
		--enable-multibyte \
		--enable-rubyinterp=yes \
		--enable-python3interp=yes \
		--with-python3-config-dir=$(python3-config --configdir) \
		--enable-perlinterp=yes \
		--enable-luainterp=yes \
		--enable-gui=gtk2 \
		--enable-cscope \
		--prefix=/usr/local
	make && sudo make install

	sudo apt remove vim vim-runtime gvim

	cd $cwd
}

compileTilda() {
	# see https://github.com/lanoxx/tilda/blob/master/HACKING.md

	local cwd=$(pwd)
	cd ~/c

	sudo apt install \
		dh-autoreconf autotools-dev debhelper \
		libconfuse-dev libgtk-3-dev libvte-2.91-dev pkg-config

	git clone https://github.com/lanoxx/tilda.git
	cd tilda
	mkdir build
	cd build

	# https://github.com/lanoxx/tilda/issues/412
	# to prevent content scrolling from toggling tilda's show state
	cat << EOF

open ../src/key_grabber.c, go to pull_up function
comment out the following part
	if (tw->fullscreen) {
		gtk_window_unfullscreen(GTK_WINDOW(tw->window));
	}


then run
	../autogen.sh --prefix=/usr/local
	make
	sudo make install
	sudo apt remove tilda
	logout the system
EOF

	cd $cwd
}

installRust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

	# install tab-indent
	cargo install --git https://github.com/mhf-air/tab-indent.git

	# git clone git@github.com:mhf-air/rust-analyzer.git
	# git remote add upstream https://github.com/rust-analyzer/rust-analyzer.git
	# cargo install --path crates/rust-analyzer --locked
}

installGo() {
	local fileName=go.linux-amd64.tar.gz
	wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz -O /tmp/$fileName
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf /tmp/$fileName
}

installNode() {
	local cwd=$(pwd)
	cd ~/software/node

	local version=v14.18.0
	local dirName=node-${version}-linux-x64
	local fileName=${dirName}.tar.xz
	wget https://nodejs.org/dist/${version}/$fileName -O $fileName
	tar -xf $fileName

	rm -f ~/.bin/node

	local src="${dirName}/bin"
	local target="node"
	ln -s $(realpath "$src") ~/.bin/"$target"

	# install yarn
	npm install --global yarn
	yarn config set registry "https://registry.npmmirror.com"
	yarn global add \
		js-beautify \
		typescript

	# I don't know when to install yapf, so I put it here
	pip3 install yapf

	cd $cwd
}

installChrome() {
	local fileName=google-chrome-stable_current_amd64.deb
	wget https://dl.google.com/linux/direct/$fileName -O /tmp/${fileName}
	sudo dpkg -i --force-depends /tmp/${fileName}
	sudo apt install -f
}

# main
main() {
	# mkHomeDir
	# cpDotFile
	# installUtility
	# installChrome

	# compileTmux
	# compileVim
	# compileTilda

	# installRust
	installNode

	# ----------------------------------------------------------------------
	# optional
	# installGo
}

main

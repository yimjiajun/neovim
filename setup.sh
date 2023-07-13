#!/bin/bash

case "$OSTYPE" in
	"linux-gnu"*)
		sudo apt update -y && sudo apt upgrade -y
		if [[ "$(command -v nala)" ]]; then
			pkg_install_cmd="sudo nala -y install"
		else
			pkg_install_cmd="sudo apt install -y"
		fi
		;;
	"darwin"*)
		brew update
		pkg_install_cmd="brew install"
		;;
	*)
		echo -e "OS-${OSTYPE} Not Support!" >&2
		exit 1
		;;
esac

function install_build_prerequisites {

	if [[ $OSTYPE == "linux-gnu" ]]; then
		$pkg_install_cmd ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

		$pkg_install_cmd gcc make pkg-config autoconf automake python3-docutils \
			libseccomp-dev libjansson-dev libyaml-dev libxml2-dev

		$pkg_install_cmd --no-install-recommends git cmake ninja-build gperf \
			ccache dfu-util device-tree-compiler wget \
			python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
			make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1

		$pkg_install_cmd build-essential libncurses-dev libjansson-dev
	elif [[ $OSTYPE == "darwin"* ]]; then
		brew tap universal-ctags/universal-ctags
		brew install --head universal-ctags
	fi
}

function install_nvim {
	local path="$1"

	git clone --depth 1 https://github.com/neovim/neovim -b stable ${path}
	make -C ${path} CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make -C ${path} install

	echo -e "NeoVim installed on /usr/local/" >&1
}

function install_node {
	if [[ "$(command -v node)" ]]; then
		return 0
	fi

	echo -e "Install nvm ..." >&1
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

	if [[ "$?" -ne 0 ]]; then
		echo -e "Install nvm failed!" >&2
		return 1
	fi

	if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
		source "$HOME/.nvm/nvm.sh"
	fi

	echo -e "Install node and npm ..." >&1
	nvm install node

	if [[ "$?" -ne 0 ]]; then
		echo -e "\033[31msudo apt-get remove --purge nodejs npm\033[0m" >&1
		echo -e "Re-install node and npm failed!" >&2
	fi

	echo -e "Install npm ... for neovim lsp" >&1
	$pkg_install_cmd npm

	if [[ "$?" -ne 0 ]]; then
		echo -e"\033[31msudo apt-get remove --purge npm\033[0m" >&1
		return 1
	fi

	$SHELL -c "source ${HOME}/.$(basename $SHELL)rc"

	local version=$(node --version | sed 's/^v\([0-9]\{1,\}\)\..*/\1/')

	if [[ $version -lt 17 ]]; then
		echo -e "Upgrade npm ..." >&1
		nvm install 17.3.0
	fi
}

function install_clangd {
	if [[ "$(command -v clangd)" ]]; then
		return 0
	fi

	echo -e "Install clangd ..." >&1

	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		sudo apt install -y clangd-12
		sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		brew install llvm
	fi
}

function install_python {
	$pkg_install_cmd python3
	$pkg_install_cmd python3-pip

	version=$(lsb_release -rs)

	if awk 'BEGIN { exit !('"$version"' >= 22.04) }'; then
		echo -e "Install python env for cmake and py lsp ..." >&1
		$pkg_install_cmd python3.10-venv
	fi
}

function install_ctags {
	path="$(mktemp -d)"
	install_path="/usr/local"

	if [[ "$(command -v ctags)" ]]; then
		return 0
	fi

	if [[ -d "$path" ]]; then
		rm -rf $path
	fi

	echo -e "Install ctags ..." >&1

	git clone https://github.com/universal-ctags/ctags.git $path
	cd $path
	./autogen.sh; ./configure --prefix="$install_path"
	make; sudo make install
}

function install_ripgrep {
	if [[ "$(command -v rg)" ]]; then
		return 0
	fi

	echo -e "Install ripgrep ..." >&1
	$pkg_install_cmd ripgrep
}

function install_ranger {
	if [[ $(command -v ranger) ]]; then
		return 0
	fi

	echo -e "Install ranger ..." >&1
	$pkg_install_cmd ranger

}

function install_htop {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return
	fi

	if [[ "$(command -v htop)" ]]; then
		return 0
	fi

	echo -e "Install htop ..." >&1
	$pkg_install_cmd htop
}

function install_fzf {
	if [[ "$(command -v fzf)" ]]; then
		return 0
	fi

	echo -e "Install fzf ..." >&1
	$pkg_install_cmd fzf
}

function install_ncdu {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return 0
	fi

	if [[ "$(command -v ncdu)" ]]; then
		return 0
	fi

	echo -e "Install ncdu ..." >&1
	$pkg_install_cmd ncdu

	return
}

function install_lazygit {
	local tmp_path="$(mktemp -d)"
	if [[ $(command -v lazygit) ]]; then
		return 0
	fi

	echo -e "Install lazygit ..." >&1

	if [[ $OSTYPE == linux-gnu* ]]; then
		cd $tmp_path
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		sudo install lazygit /usr/local/bin
	else
		$pkg_install_cmd lazygit
	fi

	return
}

function main {
	local neovim_install_path="$(mktemp -d)"
	local neovim_config_path="$HOME/.config/nvim"

	echo -e "\033[33mSetup Neovim\033[0m" >&1

	if [[ -z "$(command -v nvim)" ]]; then
		install_build_prerequisites

		if [[ -d "$neovim_install_path" ]]; then
			rm -rf $neovim_install_path
		fi

		install_nvim $neovim_install_path
	fi

	install_node
	install_clangd
	install_python
	install_ctags
	install_ripgrep
	install_ranger
	install_htop
	install_fzf
	install_ncdu
	install_lazygit

	$SHELL -c "source ${HOME}/.$(basename $SHELL)rc"

	echo -e "Success setup neovim!" >&1
}

main "$@"

exit 0

#!/bin/bash

case "$OSTYPE" in
	"linux-gnu"*)
		if [[ "$(command -v nala)" ]]; then
			pkg_install_cmd="sudo nala -y install"
		else
			pkg_install_cmd="sudo apt install -y"
		fi
		;;
	"darwin"*)
		pkg_install_cmd="brew install"
		;;
	*)
		echo -e "OS-${OSTYPE} Not Support!" >&2
		exit 1
		;;
esac

function run {
	if [[ -z "$1" ]]; then
		echo "Usage: $0 run [nvim|nvim-qt]"
		exit 1
	fi

	# if nvim command found
	if [[ -n "$(command -v nvim)" ]]; then
		if [[ "$1" == "nvim" ]]; then
			nvim
		elif [[ "$1" == "nvim-qt" ]]; then
			nvim-qt
		else
			echo "Usage: $0 run [nvim|nvim-qt]"
			exit 1
		fi
	else
		echo -e "\033[31mNeovim not installed!\033[0m" >&2
		echo -e "Please run \033[32m$0 install\033[0m to install it." >&2
		exit 1
	fi
}

function install {
	function install_build_prerequisites {
		if [[ $OSTYPE == "linux-gnu" ]]; then
			$pkg_install_cmd ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
			$pkg_install_cmd gcc make pkg-config autoconf automake python3-docutils \
				libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
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

	function install_nvim_config {
		path="$1"

		if [[ -d "$path" ]]; then
			read -p "Neovim config already exists, do you want to overwrite it? [y/n] " -n 1 -r

			if [[ $REPLY =~ ^[Yy]$ ]]; then
				rm -rf $path
			else
				return 0
			fi
		fi

		git clone https://github.com/yimjiajun/neovim.git $path
	}

	function packer_manager_install {
		local path="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

		echo -e "Install Neovim packer manager" >&1

		if [[ ! -d "$path" ]]; then
			git clone --depth 1 https://github.com/wbthomason/packer.nvim "$path"
		else
			git -C "$path" pull
		fi

		return
	}

	function relative_tools_install {
		function install_node {
			if [[ "$(command -v npm)" ]]; then
				return 0
			fi

			echo -e "Install nvm ..." >&1
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
			echo -e "Install node and npm ..." >&1
			nvm install node
			if [[ "$?" -ne 0 ]]; then
				echo -e "\033[31msudo apt-get remove --purge nodejs npm\033[0m" >&1
				echo -e "Re-install node and npm failed!" >&2
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

		function install_python_env {
			version=$(lsb_release -rs)

			if awk 'BEGIN { exit !('"$version"' >= 22.04) }'; then
				echo -e "Install python env for cmake and py lsp ..." >&1
				sudo apt install -y python3.10-venv
			fi
		}

		function install_ctags {
			path="/tmp/ctags"
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
			./autogen.sh
			./configure --prefix="$install_path"
			make
			sudo make install
		}

		install_node
		install_clangd
		install_python_env
		install_ctags
	}

	local neovim_install_path='/tmp/neovim'
	local neovim_config_path="$HOME/.config/nvim"

	echo -e "\033[33mInstall Neovim\033[0m" >&1

	if [[ -z "$(command -v nvim)" ]]; then
		install_build_prerequisites

		if [[ -d "$neovim_install_path" ]]; then
			rm -rf $neovim_install_path
		fi

		install_nvim $neovim_install_path
	fi

	packer_manager_install

	# install_nvim_config $neovim_config_path

	relative_tools_install

	nvim +PackerSync
}

function link {
	echo -e "\033[33mLink Neovim config\033[0m" >&1
	echo -e "Please run \033[32m$0 install\033[0m to install it." >&2
}

function main {
	if [[ -z "$1" ]]; then
		echo "Usage: $0 [run|install|link]"
		exit 1
	fi

	case "$1" in
		run)
			run
			;;
		install)
			install
			;;
		link)
			link
			;;
		*)
			echo "Usage: $0 [run|install|link]"
			exit 1
			;;
	esac
}

main "$@"
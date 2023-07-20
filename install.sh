#!/bin/bash

function install_build_prerequisites {
	echo -e "● Install build prerequisites..." >&1

	if [[ $OSTYPE == "linux-gnu" ]]; then
		$pkg_install_cmd \
			ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen \
			1>/dev/null || {
				echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
				exit 1
			}

		$pkg_install_cmd \
			gcc make pkg-config autoconf automake python3-docutils \
			libseccomp-dev libjansson-dev libyaml-dev libxml2-dev \
			1>/dev/null || {
				echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
				exit 1
			}

		$pkg_install_cmd --no-install-recommends \
			git cmake ninja-build gperf \
			ccache dfu-util device-tree-compiler wget \
			python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
			make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
			1>/dev/null || {
				echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
				exit 1
			}

		$pkg_install_cmd \
			build-essential libncurses-dev libjansson-dev \
			1>/dev/null || {
				echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
				exit 1
			}
	elif [[ $OSTYPE == "darwin"* ]]; then
		brew tap universal-ctags/universal-ctags 1>/dev/null || {
			echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
			exit 1
		}

		brew install --head universal-ctags 1>/dev/null || {
			echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
			exit 1
		}
	fi
}

function install_nvim {
	local path="$1"

	echo -e "● Download neovim repository..." >&1
	git clone --depth 1 https://github.com/neovim/neovim -b stable ${path} || {
		echo -e "\033[31mError: git clone neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● Build neovim..." >&1
	make -C ${path} CMAKE_BUILD_TYPE=RelWithDebInfo 1>/dev/null || {
		echo -e "\033[31mError: make neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● Install neovim..." >&1
	sudo make -C ${path} install 1>/dev/null || {
		echo -e "\033[31mError: make install neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● NeoVim installed on /usr/local/" >&1
}

function install_node {
	if [[ "$(command -v node)" ]]; then
		return 0
	fi

	echo -e "● Install nvm ..." >&1
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash 1>/dev/null || {
		echo -e "\033[31mError: Install nvm failed!\033[0m" >&2
		return 1
	}

	echo

	if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
		source "$HOME/.nvm/nvm.sh"
	fi

	echo -e "● Install node and npm ..." >&1

	nvm install node 1>/dev/null || {
		echo -e "\033[31mError: Install node and npm failed!\033[0m" >&2
		echo -e "\033[31m● sudo apt-get remove --purge nodejs npm\033[0m" >&2
		echo -e "\033[31m● Re-install node and npm !\033[0m" >&2
		return 1
	}

	echo -e "● Install npm ... NeoVim LSP" >&1
	$pkg_install_cmd npm 1>/dev/null || {
		echo -e "\033[31mError: Install npm failed!\033[0m" >&2
		echo -e"\033[31m● sudo apt-get remove --purge npm\033[0m" >&1
		return 1
	}

	$SHELL -c "source ${HOME}/.$(basename $SHELL)rc"

	local version=$(node --version | sed 's/^v\([0-9]\{1,\}\)\..*/\1/')

	if [[ $version -lt 17 ]]; then
		echo -e "● Upgrade npm ..." >&1
		nvm install 17.3.0
	fi

	return 0
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

	echo -e "● Install ctags ..." >&1

	git clone https://github.com/universal-ctags/ctags.git $path 1>/dev/null || {
		echo -e "\033[31mError: git clone ctags failed!\033[0m" >&2
		exit 1
	}

	cd $path

	echo -e "● ctags auto generation ..." >&1
	./autogen.sh 1>/dev/null || {
		echo -e "\033[31mError: autogen ctags failed!\033[0m" >&2
		exit 1
	}

	echo -e "● ctags configure ..." >&1
	./configure --prefix="$install_path" 1>/dev/null || {
		echo -e "\033[31mError: configure ctags failed!\033[0m" >&2
		exit 1
	}

	echo -e "● ctags make ..." >&1
	make 1>/dev/null 2>&1 || {
		echo -e "\033[31mError: make ctags failed!\033[0m" >&2
		exit 1
	}

	echo -e "● ctags make install ..." >&1
	sudo make install 1>/dev/null || {
		echo -e "\033[31mError: make install ctags failed!\033[0m" >&2
		exit 1
	}
}

function install_ripgrep {
	if [[ "$(command -v rg)" ]]; then
		return 0
	fi

	echo -e "● Install ripgrep ..." >&1
	$pkg_install_cmd ripgrep 1>/dev/null || {
		echo -e "\033[31mError: Install ripgrep failed!\033[0m" >&2
		exit 1
	}
}

function install_ranger {
	if [[ $(command -v ranger) ]]; then
		return 0
	fi

	echo -e "● Install ranger ..." >&1
	$pkg_install_cmd ranger 1>/dev/null || {
		echo -e "\033[31mError: Install ranger failed!\033[0m" >&2
		exit 1
	}
}

function install_htop {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return 0
	fi

	if [[ "$(command -v htop)" ]]; then
		return 0
	fi

	echo -e "● Install htop ..." >&1
	$pkg_install_cmd htop 1>/dev/null || {
		echo -e "\033[31mError: Install htop failed!\033[0m" >&2
		exit 1
	}
}

function install_fzf {
	if [[ "$(command -v fzf)" ]]; then
		return 0
	fi

	echo -e "● Install fzf ..." >&1
	$pkg_install_cmd fzf 1>/dev/null || {
		echo -e "\033[31mError: Install fzf failed!\033[0m" >&2
		exit 1
	}
}

function install_ncdu {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return 0
	fi

	if [[ "$(command -v ncdu)" ]]; then
		return 0
	fi

	echo -e "● Install ncdu ..." >&1
	$pkg_install_cmd ncdu 1>/dev/null || {
		echo -e "\033[31mError: Install ncdu failed!\033[0m" >&2
		exit 1
	}
}

function install_lazygit {
	local tmp_path="$(mktemp -d)"

	if [[ $(command -v lazygit) ]]; then
		return 0
	fi

	echo -e "● Install lazygit ..." >&1

	if [[ $OSTYPE == linux-gnu* ]]; then
		cd $tmp_path
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo $tmp_path/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" 1>/dev/null || {
			echo -e "\033[31mError: Download lazygit failed!\033[0m" >&2
			exit 1
		}

		tar xf $tmp_path/lazygit.tar.gz $tmp_path/lazygit || {
			echo -e "\033[31mError: Extract lazygit failed!\033[0m" >&2
			exit 1
		}

		sudo install $tmp_path/lazygit /usr/local/bin || {
			echo -e "\033[31mError: Install lazygit failed!\033[0m" >&2
			exit 1
		}
	else
		$pkg_install_cmd lazygit 1>/dev/null || {
			echo -e "\033[31mError: Install lazygit failed!\033[0m" >&2
			exit 1
		}
	fi
}

function install_khal {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return 0
	fi

	if [[ "$(command -v khal)" ]]; then
		return 0
	fi

	echo -e "● Install khal ..." >&1
	$pkg_install_cmd khal 1>/dev/null || {
		echo -e "\033[31mError: Install khal failed!\033[0m" >&2
		exit 1
	}
}

function install_bpytop {
	if [[ $OSTYPE != linux-gnu* ]]; then
		return 0
	fi

	if [[ "$(command -v bpytop)" ]]; then
		return 0
	fi

	echo -e "● Install bpytop ..." >&1
	pip3 install --upgrade-strategy eager bpytop 1>/dev/null || {
		echo -e "\033[31mError: Install bpytop failed!\033[0m" >&2
		exit 1
	}
}

display_center() {
	local text="$1"
	local text_width=${#text}
	local screen_width="$(tput cols)"
	local padding_width=$(( ($screen_width - $text_width) / 2 ))
	printf "%${padding_width}s" " "
	printf "%s\n" "$text"
}

display_title () {
	local text="$1"
	local screen_width="$(tput cols)"

	for delimiter in {1..2}; do
		for ((i=0; i<$screen_width; i++)); do
			echo -n "="
		done

		echo ""

		echo -e -n "\e[1;33m"
		if [ $delimiter -eq 1 ]; then
			display_center "$text"
		fi
		echo -e -n "\e[0m"
	done
}

function main {
	local neovim_install_path="$(mktemp -d)"
	local neovim_config_path="$HOME/.config/nvim"

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
	install_khal
	install_bpytop

	$SHELL -c "source ${HOME}/.$(basename $SHELL)rc"
}

display_title "Setup Neovim"

case "$OSTYPE" in
	"linux-gnu"*)
		sudo apt-get update -y 1>/dev/null && sudo apt-get upgrade -y 1>/dev/null || {
			echo -e "\033[31mError: Update apt failed!\033[0m" >&2
			exit 1
		}

		if [[ "$(command -v nala)" ]]; then
			pkg_install_cmd="sudo nala install -y"
		else
			pkg_install_cmd="sudo apt-get install -y"
		fi
		;;
	"darwin"*)
		brew update 1>/dev/null || {
			echo -e "\033[31mError: Update brew failed!\033[0m" >&2
			exit 1
		}

		pkg_install_cmd="brew install"
		;;
	*)
		echo -e "OS-${OSTYPE} Not Support!" >&2
		exit 1
		;;
esac

main "$@"
display_title "Success Setup Neovim!"

exit 0

#!/bin/bash

display_center() {
	local text="$1"
	local text_width=${#text}
	local screen_width="$(tput cols)"
	local padding_width=$(( (screen_width - text_width) / 2 ))
	printf "%${padding_width}s" " "
	printf "%s\n" "$text"
}

display_title () {
	local text="$1"
	local screen_width="$(tput cols)"

	for delimiter in {1..2}; do
		for ((i=0; i<screen_width; i++)); do
			echo -n "="
		done

		echo ""

		echo -e -n "\e[1;33m"
		if [ "$delimiter" -eq 1 ]; then
			display_center "$text"
		fi
		echo -e -n "\e[0m"
	done
}

function pre_install_build_prerequisites {
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
			python-is-python3 \
			make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 \
			1>/dev/null || {
				echo -e "\033[31mError: Install build prerequisites failed!\033[0m" >&2
				exit 1
			}

		$pkg_install_cmd \
			build-essential libncurses-dev libjansson-dev \
			libreadline-dev \
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

function post_install_nvim {

	if [[ $(command -v nvim) ]]; then
		return 0
	fi

	local path=$(mktemp -d)

	echo -e "● Download neovim repository..." >&1
	git clone --depth 1 https://github.com/neovim/neovim -b stable "${path}" || {
		echo -e "\033[31mError: git clone neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● Build neovim..." >&1
	make -C "${path}" CMAKE_BUILD_TYPE=RelWithDebInfo 1>/dev/null || {
		echo -e "\033[31mError: make neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● Install neovim..." >&1
	sudo make -C "${path}" install 1>/dev/null || {
		echo -e "\033[31mError: make install neovim failed!\033[0m" >&2
		exit 1
	}

	echo -e "● NeoVim installed on /usr/local/" >&1
}

function pre_install_node {
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

	$SHELL -c "source ${HOME}/.$(basename "$SHELL")rc"

	local version=$(node --version | sed 's/^v\([0-9]\{1,\}\)\..*/\1/')

	if [[ $version -lt 17 ]]; then
		echo -e "● Upgrade npm ..." >&1
		nvm install 17.3.0
	fi

	return 0
}

function pre_install_python {
	$pkg_install_cmd python3 1>/dev/null || {
		echo -e "\033[31mError: Install python3 failed!\033[0m" >&2
		return 1
	}

	$pkg_install_cmd python3-pip 1>/dev/null || {
		echo -e "\033[31mError: Install python3-pip failed!\033[0m" >&2
		return 1
	}

	version=$(lsb_release -rs)

	if awk 'BEGIN { exit !('"$version"' >= 22.04) }'; then
		echo -e "Install python env for cmake and py lsp ..." >&1
		$pkg_install_cmd python3.10-venv 1>/dev/null || {
			echo -e "\033[31mError: Install python3.10-venv failed!\033[0m" >&2
			return 1
		}
	fi

   python3 -m pip install --user --upgrade pynvim 1>/dev/null || {
	   echon -e "\033[31mError: Install pynvim failed!\033[0m" >&2
   }
}

function install_ctags {
	path="$(mktemp -d)"
	install_path="/usr/local"

	if [[ "$(command -v ctags)" ]]; then
		return 0
	fi

	echo -e "● Install ctags ..." >&1

	git clone https://github.com/universal-ctags/ctags.git "$path" 1>/dev/null || {
		echo -e "\033[31mError: git clone ctags failed!\033[0m" >&2
		return 1
	}

	cd "$path" || exit

	echo -e "● ctags auto generation ..." >&1
	./autogen.sh 1>/dev/null || {
		echo -e "\033[31mError: autogen ctags failed!\033[0m" >&2
		return 1
	}

	echo -e "● ctags configure ..." >&1
	./configure --prefix="$install_path" 1>/dev/null || {
		echo -e "\033[31mError: configure ctags failed!\033[0m" >&2
		return 1
	}

	echo -e "● ctags make ..." >&1
	make 1>/dev/null 2>&1 || {
		echo -e "\033[31mError: make ctags failed!\033[0m" >&2
		return 1
	}

	echo -e "● ctags make install ..." >&1
	sudo make install 1>/dev/null || {
		echo -e "\033[31mError: make install ctags failed!\033[0m" >&2
		return 1
	}
}

function install_ripgrep {
	if [[ "$(command -v rg)" ]]; then
		return 0
	fi

	echo -e "● Install ripgrep ..." >&1
	$pkg_install_cmd ripgrep 1>/dev/null || {
		echo -e "\033[31mError: Install ripgrep failed!\033[0m" >&2
		return 1
	}
}

function install_ranger {
	if [[ $(command -v ranger) ]]; then
		return 0
	fi

	echo -e "● Install ranger ..." >&1
	$pkg_install_cmd ranger 1>/dev/null || {
		echo -e "\033[31mError: Install ranger failed!\033[0m" >&2
		return 1
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
		return 1
	}
}

function install_fzf {
	if [[ "$(command -v fzf)" ]]; then
		return 0
	fi

	echo -e "● Install fzf ..." >&1
	$pkg_install_cmd fzf 1>/dev/null || {
		echo -e "\033[31mError: Install fzf failed!\033[0m" >&2
		return 1
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
		return 1
	}
}

function install_lazygit {
	local tmp_path="$(mktemp -d)"

	if [[ $(command -v lazygit) ]]; then
		return 0
	fi

	echo -e "● lazygit installation" >&1

	if [[ $OSTYPE == linux-gnu* ]]; then
		cd "$tmp_path" || exit
		echo -e "● Download lazygit ..." >&1
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
		curl -Lo "$tmp_path"/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" 1>/dev/null || {
			echo -e "\033[31mError: Download lazygit failed!\033[0m" >&2
			return 1
		}

		echo -e "● Extract lazygit ..." >&1

		tar xf "$tmp_path"/lazygit.tar.gz -C "$tmp_path" || {
			echo -e "\033[31mError: Extract lazygit failed!\033[0m" >&2
			return 1
		}

		echo -e "● Install lazygit ..." >&1

		sudo install "$tmp_path"/lazygit /usr/local/bin || {
			echo -e "\033[31mError: Install lazygit failed!\033[0m" >&2
			return 1
		}
	else
		$pkg_install_cmd lazygit 1>/dev/null || {
			echo -e "\033[31mError: Install lazygit failed!\033[0m" >&2
			return 1
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
		return 1
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
		return 1
	}
}

function pre_install_cargo {

	if [[ $(command -v rustup) ]]; then
		return 0
	fi

	display_center "Install cargo"

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y || {
		echo -e "\033[31mError: Install rustup failed!\033[0m" >&2
		return 1
	}

	if [[ -f "$HOME/.cargo/env" ]]; then
		if [[ -f "$HOME/.$(basename "$SHELL")rc" ]] && \
			[[ $(grep -c "source $HOME/.cargo/env" "$HOME/.$(basename "$SHELL")rc") -eq 0 ]]; \
		then
			echo "source $HOME/.cargo/env" >> "$HOME"/".$(basename "$SHELL")rc"
		fi

		source "$HOME/.cargo/env" || {
			echo -e "\033[31mError: source $HOME/.cargo/env failed!\033[0m" >&2
			return 1
		}

		rustup default stable || {
			echo -e "\033[31mError: rustup default stable failed!\033[0m" >&2
			return 1
		}
	else
		echo -e "\033[31mError: $HOME/.cargo/env not found!\033[0m" >&2
		return 1
	fi
}

function install_dutree {

	if [[ $(command -v dutree) ]]; then
		return 0
	fi

	display_center "Install dutree"

	if [[ -z $(command -v cargo) ]]; then
		echo -e "\e[33mWarning: skip to install dutree ... cargo nout found\e[0m" >&2
		return 0
	fi

	cargo install dutree 1>/dev/null || {
		echo -e "\033[31mError: Install dutree failed!\033[0m" >&2
		return 1
	}

	return 0
}

function install_gitui {

	if [[ $(command -v gitui) ]]; then
		return 0
	fi

	display_center "Install gitui"

	local arch="$(uname -m)"
	local pkg=nil
	local ver='v0.23.0'

	if [[ $OSTYPE == darwin* ]]; then
		pkg='gitui-mac.tar.gz'
	elif [[ $OSTYPE == linux-gnu* ]]; then
		if [[ $arch == 'x86_64' ]]; then
			pkg='gitui-linux-musl.tar.gz'
		elif [[ $arch == 'aarch64' ]]; then
			pkg='gitui-linux-aarch64.tar.gz'
		else
			echo -e "\e[33mWarning: skip to install gitui ... arch $arch not supported\e[0m" >&2
			return 0
		fi
	else
		echo -e "\e[33mWarning: skip to install gitui ... os $OSTYPE not supported\e[0m" >&2
		return 0
	fi

	local tmp_path=$(mktemp -d)

	curl -Lo "$tmp_path"/"$pkg" "https://github.com/extrawurst/gitui/releases/download/${ver}/${pkg}" || {
		echo -e "\033[31mError: download gitui failed!\033[0m" >&2
		return 1
	}

	tar -zxf "$tmp_path"/"$pkg" -C "$HOME"/.local/bin/ || {
		echo -e "\033[31mError: Extract gitui failed!\033[0m" >&2
		return 1
	}

	return 0
}

function pre_install_luarocks() {
	local lua_version='5.3.5'
	local luarocks_version='3.9.2'
	local temp_path=$(mktemp -d)

	if [[ $(command -v luarocks) ]]; then
		return 0
	fi

	if [[ "$OSTYPE" == darwin* ]]; then
	   brew install luarocks || {
		   return 1
	   }
	fi

	version="$lua_version"

	curl -Lo $temp_path/lua-${version}.tar.gz \
		http://www.lua.org/ftp/lua-${version}.tar.gz || {
		echo -e "\033[31mError: Download luarocks failed!\033[0m" >&2
		return 1
	}

	cd $temp_path || {
		echo -e "\033[31mError: cd $temp_path failed!\033[0m" >&2
		return 1
	}

	tar -zxf lua-${version}.tar.gz || {
		echo -e "\033[31mError: Extract luarocks failed!\033[0m" >&2
		return 1
	}

	cd lua-${version} || {
		echo -e "\033[31mError: cd luarocks-${version} failed!\033[0m" >&2
		return 1
	}

	make linux test 1>/dev/null || {
		echo -e "\033[31mError: configure luarocks failed!\033[0m" >&2
		return 1
	}

	sudo make install 1>/dev/null || {
		echo -e "\033[31mError: make luarocks failed!\033[0m" >&2
		return 1
	}

	version="$luarocks_version"

	curl -Lo $temp_path/luarocks-${version}.tar.gz \
		https://luarocks.org/releases/luarocks-${version}.tar.gz || {
		echo -e "\033[31mError: Download luarocks failed!\033[0m" >&2
		return 1
	}

	cd $temp_path || {
		echo -e "\033[31mError: cd $temp_path failed!\033[0m" >&2
		return 1
	}

	tar zxpf luarocks-${version}.tar.gz || {
		echo -e "\033[31mError: Extract luarocks failed!\033[0m" >&2
		return 1
	}

	cd luarocks-${version} || {
		echo -e "\033[31mError: cd luarocks-${version} failed!\033[0m" >&2
		return 1
	}

	./configure 1>/dev/null || {
		echo -e "\033[31mError: configure luarocks failed!\033[0m" >&2
		return 1
	}

	make 1>/dev/null || {
		echo -e "\033[31mError: make luarocks failed!\033[0m" >&2
		return 1
	}

	sudo make install 1>/dev/null || {
		echo -e "\033[31mError: make luarocks failed!\033[0m" >&2
		return 1
	}

	sudo luarocks install luasocket 1>/dev/null || {
		echo -e "\033[31mError: install luasocket failed!\033[0m" >&2
		return 1
	}
}

function coc_nodejs() {
	if [[ "$(command -v node)" ]]; then
		return 0
	fi

	curl -sL install-node.vercel.app/lts | bash || {
		echo -e "\033[31mError: Install nodejs failed!\033[0m" >&2
			return 1
		}
}

function install_lsp_bash() {
	if [[ "$(command -v bash-language-server)" ]]; then
		return 0
	fi

	echo -e "● Install bash-language-server ..." >&1
	npm install -g bash-language-server 1>/dev/null || {
		echo -e "\033[31mError: Install bash-language-server failed!\033[0m" >&2
		return 1
	}
}

function install_lsp_clangd() {
	if [[ "$(command -v clangd)" ]]; then
		return 0
	fi

	if [[ "$OSTYPE" == "darwin"* ]]; then
		brew install llvm || {
			echo -e "\033[31mError: Install llvm failed!\033[0m" >&2
			return 1
		}
	fi

	sudo apt-get install clangd-12 || {
		echo -e "\033[31mError: Install clangd failed!\033[0m" >&2

		sudo apt-get install clangd-9 \
			|| sudo apt-get install clangd-8 \
			|| sudo apt-get install clangd || {
			echo -e "\033[31mError: Install clangd failed!\033[0m" >&2
			return 1

		}

		sudo update-alternatives --install \
			/usr/bin/clangd clangd /usr/bin/clangd-12 100 \
		|| {
			echo -e "\033[31mError: update-alternatives clangd failed!\033[0m" >&2
			return 1
		}
	}
}

function install_lsp_cmake() {
	if [[ "$(command -v cmake-language-server)" ]]; then
		return 0
	fi

	pip install cmake-language-server 1>/dev/null || {
		echo -e "\033[31mError: Install cmake-language-server failed!\033[0m" >&2
		return 1
	}
}

function install_lsp_lua() {
	if [[ "$(command -v lua-lsp)" ]]; then
		return 0
	fi

	if [[ -z "$(command -v luarocks)" ]]; then
		echo -e "\033[31mError: Install lua-language-server failed!\033[0m" >&2
		return 1
	fi

	sudo luarocks install --server=http://luarocks.org/dev lua-lsp 1>/dev/null || {
		echo -e "\033[31mError: Install lua-language-server failed!\033[0m" >&2
		return 1
	}

	sudo luarocks install luacheck 1>/dev/null || {
		echo -e "\033[31mError: Install luacheck failed!\033[0m" >&2
		return 1
	}
}

function install_lsp_python() {
	if [[ "$(command -v pyright)" ]]; then
		return 0
	fi

	pip install pyright 1>/dev/null || {
		echo -e "\033[31mError: Install pyright failed!\033[0m" >&2
		return 1
	}
}

function install_lsp_rust() {
	if [[ "$(command -v rust-analyzer)" ]]; then
		return 0
	fi

	if [[ -z "$(command -v rustup)" ]]; then
		echo -e "\033[31mError: Install rust-analyzer failed!\033[0m" >&2
		return 1
	fi

	rustup component add rust-src || {
		echo -e "\033[31mError: rustup component add rust-src failed!\033[0m" >&2
		return 1
	}
}

function main {
	local install_failed=0
	local status_pkgs=()
	local pre_install_pkgs=( $(declare -F | awk '{print $3}' | grep -E "^pre_install_"))
	local intsall_pkgs=( $(declare -F | awk '{print $3}' | grep -E "^install_"))
	local post_install_pkgs=( $(declare -F | awk '{print $3}' | grep -E "^post_install_"))
	local pkgs=( "${pre_install_pkgs[@]}" "${intsall_pkgs[@]}" "${post_install_pkgs[@]}" )


	for pkg in "${pkgs[@]}"; do
		display_title "Install $(sed 's/\w*install_//g' <<< "$pkg")"
		$pkg
		ret=$?

		if [[ $ret -ne 0 ]]; then
			if [[ $ret -eq 3 ]]; then
				echo -e "\e[33mWarning: skip install $(sed 's/\w*install_//g' <<< "$pkg")\e[0m" >&2
				status_pkgs+=("skip")
			else
				echo -e "\e[31mError: install $(sed 's/\w*install_//g' <<< "$pkg") failed!\e[0m" >&2
				install_failed=1
				status_pkgs+=("fail")
			fi
		else
			echo -e "\e[32mSuccess: install $(sed 's/\w*install_//g' <<< "$pkg") success!\e[0m" >&2
			status_pkgs+=("ok")
		fi
	done

	$SHELL -c "source ${HOME}/.$(basename "$SHELL")rc"

	display_title "Installation Status"

	for ((i=0; i<${#pkgs[@]}; i++)); do
		pkg=${pkgs[$i]}
		status=${status_pkgs[$i]}
		printf "%-2d %20s" "$(($i+1))" "$(sed 's/\w*install_//g' <<< "$pkg")"

		if [[ "$status" == fail ]]; then
			echo -e -n "\e[31m"
		elif [[ "$status" == skip ]]; then
			echo -e -n "\e[33m"
		else
			echo -e -n "\e[32m"
		fi

		echo -e "\t[ $status ]\e[0m"
	done

	if [[ $install_failed -eq 1 ]]; then
		echo -e "\e[31mError: install failed !\e[0m"
		return 1
	fi

	return 0
}

display_title "Setup Neovim"

case "$OSTYPE" in
	"linux-gnu"*)
		(sudo apt-get update -y 1>/dev/null && sudo apt-get upgrade -y 1>/dev/null) || {
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

main "$@" || {
	display_center "\e[31mSetup Neovim failed !\e[0m"
	exit 1
}

display_title "Success Setup Neovim!"

exit 0

#!/bin/bash
# Syntax check and format Lua files
# Usage: ./syntax.sh
# Dependencies: luaformatter, luacheck, shfmt
if [ "$#" -ne 0 ]; then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    cat <<-EOF
    Syntax check and format Lua files

    Usage:
        ./syntax.sh
        find . -name '*.lua' | xargs ./syntax.sh
        find . -name '*.lua' -exec ./syntax.sh {} +

    Dependencies: luaformatter, luacheck, shfmt
EOF
    exit 0
  fi

  files="$@"
else
  files=$(git diff --diff-filter=ACM --name-only)
fi

lua_tool_cmd=("stylua" "luacheck")
lua_tool_install_cmd=(
  "cargo install stylua --features lua54"
  "luarocks install luacheck")
idx=0
title="Syntax Check"
cols=$(tput cols)
output_format='echo -e "$(printf "%0.s " $(seq 1 $((($cols - 20) / 2))))${title}$(printf "%0.s " $(seq 1 $((($cols - 20) / 2))))"'
header_delimiter='echo -e "$(printf "%0.s=" $(seq 1 $cols))"'
sub_delimiter='echo -e "$(printf "%0.s-" $(seq 1 $cols))"'

tput reset
echo -e "\033[0;33m"
eval $header_delimiter
eval $output_format
eval $header_delimiter
echo -e "\033[0m"

title="Formatting Lua Files"
eval $output_format
eval $sub_delimiter

for cmd in ${lua_tool_cmd[@]}; do
  if ! command -v $cmd &>/dev/null; then
    eval ${lua_tool_install_cmd[$idx]}
  fi

  idx=$((idx + 1))
done

for f in $files; do
  if [[ $f == *.lua ]]; then
    lua_fmt_cmd="stylua"
    if ! command -v ${lua_fmt_cmd} &>/dev/null; then
      echo -e "\033[0;31mError: ${lua_fmt_cmd} not found\033[0m"
      exit 1
    fi

    if ! ${lua_fmt_cmd} $f; then
      echo -e "\033[0;31mError: ${lua_fmt_cmd} $f failed\033[0m"
      exit 1
    fi

    echo -e "Formatting $f\t\t\033[0;32mOK\033[0m"
  fi

  if [[ $f == *.sh ]] && command -v shfmt &>/dev/null; then
    if ! shfmt -i 2 -ci -bn -w $f; then
      echo -e "\033[0;31mError: shfmt $f failed\033[0m"
      exit 1
    fi

    echo -e "Formatting $f\t\t\033[0;32mOK\033[0m"
  fi
done

title="Linting Lua Files"
eval $output_format
eval $sub_delimiter

if ! command -v luacheck &>/dev/null; then
  echo -e "\033[0;31mError: luacheck not found\033[0m"
  exit 1
fi

for f in $files; do
  if [[ $f == *.lua ]]; then
    if ! luacheck --no-max-line-length $f --globals vim; then
      echo -e "\033[0;31mError: luacheck $f failed\033[0m"
      exit 1
    fi
  fi
done

exit 0

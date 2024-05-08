#!/bin/bash

if ! luacheck lua/ --globals vim; then
    echo -e "\033[0;31mError: luacheck failed\033[0m"
    exit 1
fi

exit 0

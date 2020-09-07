#!/usr/bin/env bash
# Author (c) 2020 Marcus Biesioroff biesior@gmail.com
# https://github.com/biesior/bash-scripts
# Latest updated in 1.0.1
# Donate author: https://www.paypal.com/paypalme/biesior/4.99EUR
#
# Description:
# Set (or reset) ANSI color, ie. uf you forgot to do it in your CLI app ;)

case "$1" in
black) echo -ne "\033[30m" ;;
red) echo -ne "\033[31m" ;;
green) echo -ne "\033[32m" ;;
yellow) echo -ne "\033[33m" ;;
blue) echo -ne "\033[34m" ;;
magenta) echo -ne "\033[35m" ;;
cyan) echo -ne "\033[36m" ;;
white) echo -ne "\033[37m" ;;
reset) echo -ne "\033[0m" ;;
*) echo -e "Use ansi script only with selected colors:
[black, red, green, yellow, blue, magenta, cyan, white]
or [reset] to disable coloring" ;;
esac

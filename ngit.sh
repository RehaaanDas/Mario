#!/bin/bash
chmod +x ~/ngit/ngit.sh

op=$1
shift

if [ -f ~/ngit/$op.sh ]; then
	~/ngit/$op.sh #@
elif [$op -eq ""]; then
	printf "\nngit version 0.01\ngit$(git --version)\n\nNgit is a Git wrapper born out of laziness attempts to make Git easier to use.\n"
else
	echo "ngit: command not found"
fi

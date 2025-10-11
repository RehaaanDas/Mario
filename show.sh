#!/bin/bash
chmod +x ~/ngit/show.sh

if [ $1 != "-detailed" ]; then
	git show --summary $1
else
	git show $2
fi

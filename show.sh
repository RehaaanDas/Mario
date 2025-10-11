#!/bin/bash
chmod +x ~/ngit/show.sh

if [ $1 != "-detailed" ]; then
	git show $1
else
	git show --summary $2
fi

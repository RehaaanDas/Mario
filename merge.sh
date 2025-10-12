#!/bin/bash
chmod +x ~/ngit/merge.sh

branch=$(git branch --show-current)
if [ $1 == into ]; then
	git checkout $2
	git merge -X theirs branch
elif [ $1 == from ]; then
	git merge $2
fi

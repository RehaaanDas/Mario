#!/bin/bash
chmod +x ~/ngit/merge.sh

git merge -s recursive -X ours $1

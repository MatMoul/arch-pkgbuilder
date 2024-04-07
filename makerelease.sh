#!/bin/bash

declare -r VERSION=${1}
declare -r MESSAGE=${2}
declare -r TAGBRANCH=main
declare CURRENTBRANCH=""

showHelp() {
	echo git-release version
}

if [ "${VERSION}" == "" ]; then
	showHelp
	echo ""
	echo "no version provided!"
	exit 1
fi

ssh -T gitea@ssh.git.netm.ch
if [ ! "${?}" = "1" ]; then
  echo "No ssh key loaded exiting..."
  exit 1
fi


CURRENTBRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ ! "${CURRENTBRANCH}" == "dev" ]; then
	echo "You are not in dev branch!"
	echo "Use dev branch to make a release!"
	exit 1
fi

git checkout "${TAGBRANCH}"
git merge "${CURRENTBRANCH}"
git push
git tag -a "${VERSION}" -m "${MESSAGE}"
git push --tags
git checkout "${CURRENTBRANCH}"

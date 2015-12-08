#!/bin/bash

VERSION="$1"
regex='^v[0-9.]{3,8}$'
if [[ $VERSION =~ $regex ]]
then
	echo "Using version $VERSION for push to master branch"
else
	echo "Not a valid version"
	echo "Script usage:"
	echo "$0 vx.x.x[.x]"
	echo "$0 v0.1.2"
	exit 1
fi

git checkout master
if test "$?" != "0"; then
	echo "Error while checking out master branch"
	exit 1
fi

git merge --squash integration
if test "$?" != "0"; then
	echo "Error while merging changes"
	exit 1
fi

git commit
if test "$?" != "0"; then
	echo "Error while commiting changes"
	exit 1
fi

git tag -a $VERSION -m "version $VERSION"
if test "$?" != "0"; then
	echo "Error while creating version tag"
	exit 1
fi

git push origin master && git push origin $VERSION
if test "$?" != "0"; then
	echo "Error while pushing changes"
	exit 1
fi

git checkout development
if test "$?" != "0"; then
	echo "Error while cheing out development"
	exit 1
fi

echo ""
echo "Done!"
echo ""
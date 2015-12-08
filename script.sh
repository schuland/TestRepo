#!/bin/bash
VERSION="$1"

regex='^v[0-9.]{3,8}$'
if [[ $VERSION =~ $regex ]]
then
	echo "Using version $VERSION for push"
else
	echo "Not a valid version"
	exit 1
fi

# checkout dev for fetching and updating 
echo "Checking out development branch"
git checkout development
if test "$?" != "0"; then
	echo "Error while checking out development branch"
	exit 1
fi

echo "Fetching and pulling updates for development"
git fetch && git pull
if test "$?" != "0"; then
	echo "Error while fetching or pulling updates for development branch"
	exit 1
fi

git checkout --orphan integration
# check if integration creation succeeded
if test "$?" == "128"; then
	echo "Integration branch already exists, merging changes into integration branch"
	git checkout integration
	if test "$?" != "0"; then
		echo "Error while checking out integration branch"
		exit 1
	fi
	git merge --squash development
	if test "$?" != "0"; then
		echo "Error while merging updates into integration branch"
		exit 1
	fi
elif test "$?" != "0"; then
	echo "Error while creating integration branch"
	exit 1
fi

echo "Commiting changes"
git commit
if test "$?" != "0"; then
	echo "Error while commiting changes"
	exit 1
fi

echo "Pushing changes to remote integration branch"
git push origin integration
if test "$?" != "0"; then
	echo "Error while pushing changes"
	exit 1
fi


#git checkout master
#git merge --squash integration
#git commit
#git tag -a $VERSION -m "version $VERSION"
#git push origin master && git push origin $VERSION
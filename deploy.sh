#!/bin/bash
#!/usr/bin/env bash

BRANCH=gh-pages
TARGET_REPO=lukasheinrich/susytools-eventloop-results.git

set -e

echo -e "Testing travis-encrypt"
echo -e "$VARNAME"

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    echo -e "Starting to deploy to Github Pages\n"
    if [ "$TRAVIS" == "true" ]; then
        git config --global user.email "travis@travis-ci.org"
        git config --global user.name "Travis"
    fi
    #using token clone gh-pages branch
    git clone --quiet --branch=$BRANCH https://${GH_TOKEN}@github.com/$TARGET_REPO results_website &> /dev/null
    #go into directory and copy data we're interested in to that directory

    cd results_website
    mkdir -p results
    git add results
    rsync -rv --exclude=.git  ../results/* results

    #add, commit and push files
    git add -f .
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to Github Pages"
    git push -fq origin $BRANCH
    echo -e "Deploy completed\n"
fi

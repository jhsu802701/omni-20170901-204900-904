#!/bin/bash

# Run this script before entering "git add" and "git commit".

sh test_app.sh

echo '----------------------------'
echo 'bundle exec brakeman -Aq -w2'
bundle exec brakeman -Aq -w2

echo '----------------------'
echo 'bundle exec rubocop -D'
bundle exec rubocop -D

echo '----------------------------------'
echo 'bundle exec rails_best_practices .'
bundle exec rails_best_practices .

echo '----------'
echo 'git status'
git status

sh outline-short.sh

echo '----------'
echo 'git status'
git status

#!/bin/bash

# This is a slightly longer version of testm.sh.

echo '----------------------------'
echo 'bundle exec brakeman -Aq -w2'
bundle exec brakeman -Aq -w2

echo '----------------------'
echo 'bundle exec rubocop -D'
bundle exec rubocop -D

echo '----------------------------------'
echo 'bundle exec rails_best_practices .'
bundle exec rails_best_practices .

sh testm.sh

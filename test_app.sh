#!/bin/bash

echo '--------------'
echo 'bundle install'
bundle install

echo '----------------'
echo 'rails db:migrate'
rails db:migrate

echo '----------'
echo 'rails test'
rails test

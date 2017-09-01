#!/bin/bash

sh pg-start.sh

echo '**********************'
echo 'Entering rails console'
bundle exec rails runner "eval(File.read 'admin_create.rb')"

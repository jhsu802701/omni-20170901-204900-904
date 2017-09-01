#!/bin/bash

# NOTE: The bundle install and database migration are skipped here.
# It is assumed that you already completed these steps, which are
# covered in the build_fast.sh script.

# This script tests the controllers only.

echo '---------------------------'
echo 'rails test test/controllers'
rails test test/controllers

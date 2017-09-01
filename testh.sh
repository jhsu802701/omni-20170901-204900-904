#!/bin/bash

# NOTE: The bundle install and database migration are skipped here.
# It is assumed that you already completed these steps, which are
# covered in the build_fast.sh script.

# This script tests the helpers and mailers only.

echo '------------------------------------'
echo 'rails test test/helpers test/mailers'
rails test test/helpers test/mailers

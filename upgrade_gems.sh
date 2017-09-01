#!/bin/bash

# Use this script for upgrading gems.

# If the version of a gem is pinned in the Gemfile, you must update
# the version number specified in that file.

# Do NOT use this script until you have set up this project with the build_fast.sh script.

echo '-------------'
echo 'bundle update'
bundle update

sh git_check.sh

echo '----------------------------------------------------------'
echo 'bundle exec gemsurance --output log/gemsurance_report.html'
bundle exec gemsurance --output log/gemsurance_report.html
echo 'The Gemsurance Report is at log/gemsurance_report.html .'

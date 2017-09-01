#!/bin/bash

# This script runs the app through code metrics.
# Violations will not stop the app from passing but will be flagged here.

echo '----------------------'
echo 'bundle install --quiet'
bundle install --quiet

# Checks for security vulnerabilities
# -A: runs all checks
# -q: output the report only; suppress information warnings
# -w2: level 2 warnings (medium and high only)
echo '----------------------------'
echo 'bundle exec brakeman -Aq -w2'
bundle exec brakeman -Aq -w2

# Checks for compliance with Sandi Metz' four rules
echo '-----------------------'
echo 'bundle exec sandi_meter'
bundle exec sandi_meter

# Update the local ruby-advisory-db advisory database
echo '-------------------------------'
echo 'bundle exec bundle-audit update'
bundle exec bundle-audit update

# Audit the gems listed in Gemfile.lock for vulnerabilities
echo '------------------------'
echo 'bundle exec bundle-audit'
bundle exec bundle-audit

# Checks for violations of the Ruby Style Guide, not recommended for legacy apps
echo '----------------------'
echo 'bundle exec rubocop -D'
bundle exec rubocop -D

# Checks the quality of Rails code, not recommended for legacy apps
echo '----------------------------------'
echo 'bundle exec rails_best_practices .'
bundle exec rails_best_practices .

# Checks for outdated and insecure gems
echo '----------------------------------------------------------'
echo 'bundle exec gemsurance --output log/gemsurance_report.html'
bundle exec gemsurance --output log/gemsurance_report.html
echo 'The Gemsurance Report is at log/gemsurance_report.html .'

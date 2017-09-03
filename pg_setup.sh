#!/bin/bash

# Get time as a UNIX timestamp (seconds elapsed since Jan 1, 1970 0:00 UTC)
n="$(date +%s)"

# Output:
# First argument if it is not blank
# Second argument if first argument is blank
anti_blank () {
  if [ -z "$1" ]; then
    echo $2
  else
    echo $1
  fi
}

#######################################################################################
# BEGIN: setting PostgreSQL database name parameters (db_root, db_dev, db_test, db_pro)
#######################################################################################

db_root='db_omni_20170901_204900_904'

db_dev="${db_root}_dev"
db_test="${db_root}_test"
db_pro="${db_root}_pro"

#################################################################################
# FINISHED: setting PostgreSQL database name parameters (db_dev, db_test, db_pro)
#################################################################################

####################################################################################
# BEGIN: setting names of environment variables (env_var_username, env_var_password)
####################################################################################

env_var_root="var_${db_root}"

env_var_username="${env_var_root}_username"
env_var_password="${env_var_root}_password"

#######################################################################################
# FINISHED: setting names of environment variables (env_var_username, env_var_password)
#######################################################################################

######################################
# BEGIN: getting username and password
######################################

db_username_def="username_${db_root}"
echo
echo "Default username: ${db_username_def}"
echo 'Enter the desired username for the database:'
read db_username_sel
db_username=$(anti_blank $db_username_sel $db_username_def)

db_password_def="long_way_stinks"
echo
echo "Default password: ${db_password_def}"
echo 'Enter the desired password for the database:'
read db_password_sel
db_password=$(anti_blank $db_password_sel $db_password_def)

echo
echo "Database name (development): ${db_dev}"
echo "Database name (testing): ${db_test}"
echo "Database name (production): ${db_pro}"
echo
echo 'Environmental variable names'
echo "Username: ${env_var_username}"
echo "Password: ${env_var_password}"
echo
echo "Username: ${db_username}"
echo "Password: ${db_password}"

#########################################
# FINISHED: getting username and password
#########################################

sh pg-start.sh

echo '--------------'
echo 'bundle install'
bundle install # Needed to run pg_setup.rb

ruby pg_setup.rb $db_dev $db_test $db_pro $env_var_username $env_var_password $db_username $db_password

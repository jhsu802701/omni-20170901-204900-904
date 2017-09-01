#!/bin/bash

# NOTE: In the Docker environment, PostgreSQL does NOT automatically start.
# As a result, this script is necessary.

echo '-----------------------------'
echo 'sudo service postgresql start'
sudo service postgresql start

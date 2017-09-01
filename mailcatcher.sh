#!/bin/bash

echo '-----------------------'
echo 'gem install mailcatcher'
gem install mailcatcher

echo '------------------------'
echo 'mailcatcher --ip 0.0.0.0'
mailcatcher --ip 0.0.0.0
echo 'View mail at http://localhost:<port number>/'
echo 'If you are developing this app in the host environment, the port number is 1080.'
echo 'If you are using Docker or Vagrant, the port number may be something else.'
# Send mail through smtp://localhost:1025

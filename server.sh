#!/bin/bash

sh pg-start.sh

echo '--------------------------------------------'
echo 'View page at http://localhost:<PORT NUMBER>/'
echo 'If you are using Docker or Vagrant, the port'
echo 'number may be different from 3000.'

if [ -f '/home/winner/shared/ports.txt' ]; then
  cat /home/winner/shared/ports.txt;
fi

echo '-------------------------------'
echo 'rails server -b 0.0.0.0 -p 3000'
rails server -b 0.0.0.0 -p 3000

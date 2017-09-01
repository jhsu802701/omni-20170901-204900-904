#!/bin/bash

PATH_HEROKU_NAME='config/heroku_name.txt'
HEROKU_NAME=''
if [ -e $PATH_HEROKU_NAME ]
then
  HEROKU_NAME=$(cat $PATH_HEROKU_NAME)
else
  echo 'If you have not already done so, you must create this app on Heroku.'
  echo 'Instructions for doing this are at'
  echo 'https://gist.github.com/jhsu802701/fdfd6e0732773b379413625463f2d2c0'
  echo ''
  echo 'Once you have done this, you are ready to move on.'
  echo ''
  echo 'Enter the name of your app:'
  read HEROKU_NAME
  echo $HEROKU_NAME > $PATH_HEROKU_NAME
  echo ''
fi
echo '-----------------------------'
echo "Heroku app name: $HEROKU_NAME"
echo "(stored at $PATH_HEROKU_NAME)"
echo ''
echo 'If you need to change the name of this Heroku app you wish to deploy to,'
echo "you must change the name stored in $PATH_HEROKU_NAME."
echo ''
echo '--------------------'
echo 'git remote rm heroku'
git remote rm heroku

echo '-----------------------------------------------------'
echo "git remote add heroku git@heroku.com:$HEROKU_NAME.git"
git remote add heroku git@heroku.com:$HEROKU_NAME.git

echo '-------------'
echo 'git remote -v'
git remote -v

echo '----------------------'
echo 'git push heroku master'
git push heroku master

echo '---------------------------'
echo 'heroku run rails db:migrate'
heroku run rails db:migrate

echo '-------------'
echo 'git remote -v'
git remote -v

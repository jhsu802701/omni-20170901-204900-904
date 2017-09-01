#!/bin/bash

sh pg-start.sh

echo '----------------------'
echo 'rails db:migrate:reset'
rails db:migrate:reset

echo '-------------'
echo 'rails db:seed'
rails db:seed

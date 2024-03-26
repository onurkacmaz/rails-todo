#!/bin/bash -e

rake db:create
rake db:migrate

exec "${@}"

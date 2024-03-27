#!/bin/bash -e

rake db:create
rake db:migrate

rails assets:precompile

rails server -e $RAILS_ENV -b 0.0.0.0

exec "${@}"

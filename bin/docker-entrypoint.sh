#!/bin/bash -e

rake db:prepare
rake db:migrate

rails assets:precompile

rails server -e $RAILS_ENV -b 0.0.0.0

exec "${@}"

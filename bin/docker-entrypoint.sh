#!/bin/bash -e

rake db:prepare
rake db:migrate

rails assets:precompile

/usr/bin/supervisord

rails server -d -e $RAILS_ENV -b 0.0.0.0

exec "${@}"

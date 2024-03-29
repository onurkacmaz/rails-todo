#!/bin/bash -e

supervisord -c /etc/supervisor/supervisord.conf -n &

rake db:prepare
rake db:migrate

rails assets:precompile

rails s -e $RAILS_ENV -b 0.0.0.0

exec "${@}"

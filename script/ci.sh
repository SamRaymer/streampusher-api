#!/bin/bash
eval "$(rbenv init -)"
echo $PATH
cp config/database.ci.yml config/database.yml
bundle install --jobs $(nproc)
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rake spec

#!/bin/bash -ex

# RVM Ruby environment
. /etc/profile.d/rvm.sh
# Use a gemset unique to each executor to enable parallel builds
gemset=$(echo ${JOB_NAME} | cut -d/ -f1)-${EXECUTOR_NUMBER}
rvm use ruby-${ruby}@${gemset} --create
rvm gemset empty --force
gem update --no-ri --no-rdoc
gem install bundler --no-ri --no-rdoc

echo "gem 'hammer_cli', :git => 'https://${GIT_HOSTNAME}/${GIT_ORGANIZATION}/hammer_cli.git', :ref => '${gitlabTargetBranch}'" > Gemfile.local

bundle install

bundle exec rake ci:setup:minitest test TESTOPTS="-v"

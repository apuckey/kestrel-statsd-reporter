#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cd ..
source `rvm env --path -- ruby-1.9.3-p286`
VIZIFY_NAME=demo bundle exec ruby report_to_statsd.rb

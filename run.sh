#/bin/bash

# This script untested...
# copy API token/key to bot-api-token.txt or edit below

echo "Note: requires rvm (ruby 2.3) and bundler"

rvm use 2.3
SLACK_API_TOKEN=$(cat bot-api-token.txt) bundle exec ruby slackbot.rb  > slackbot.log

#!/usr/bin/ruby
require 'slack-ruby-bot'
#require 'celluloid-io'
require './botdb'

# NOTE: bot name currently hardcoded, edit below as appropriate!

class Testbot < SlackRubyBot::Bot
    DBFILE = "slack.dat"
    myDB = DB.new(DBFILE)
    myDB.load

    match /^slackbot.*$/ do |client, data, match|
      #client.say(channel: data.channel, text: "caught: #{match}")
      input = String.new("#{match}")
      stermstring = input.downcase.gsub(/^slackbot/, "")
      #p "input = #{input}  match: #{match} " #  stermstring: #{stermstring}"
      stermstring.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      response = myDB.query(stermstring)
      #response = stermstring.class
      client.say(channel: data.channel, text: "#{response}")
    end
    
    match /^((?!slackbot).)*$/ do |client, data, match|
      input = String.new("#{match}")
      input.gsub!(/^[a-zA-Z0-9^_-]{1,12}:/, "")
      myDB.append(input)
    end
 
end

#myDB.load
Testbot.run


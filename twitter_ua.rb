#!/usr/bin/env ruby

require "twitter"
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'open-uri'
require 'net/http'
require 'pg'
require 'active_record'
require 'pry'

puts "Starting up"
#setup database
ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL", "postgres://localhost"))

class Tweet < ActiveRecord::Base
    attr_accessible :message, :tweet_id
end

# Twitter API Keys
# TODO: Save Keys to Environment Vars
apiKey = ENV['TWITTER_API_KEY']
apiSecret = ENV['TWITTER_API_SECRET'] 
accessToken = ENV['TWITTER_ACCESS_TOKEN']
accessTokenSecret = ENV['TWITTER_ACCESS_SECRET']
ua_id = ENV["GOOGLE_TWITTER_UA_ID"] 
twitter_search = ENV["TWITTER_SEARCH"]  # e.g. to:harrys
 
# config twitter api
Twitter.configure do |config|
  config.consumer_key = apiKey
  config.consumer_secret = apiSecret
  config.oauth_token = accessToken
  config.oauth_token_secret = accessTokenSecret
end

# config google api
if ENV["WEB"]
    return
end


baseurl = "http://www.google-analytics.com"
path    = "/collect"
address = URI.parse(baseurl + path)
http = Net::HTTP.new(address.host, address.port)

payload = {
    v: 1,
    tid: ua_id,
    cid: 555,
    t: "pageview",
    dl: "http://testapp.harrys.com",
    dp: "tweet",
    dt: "mention"
}
trap('SIGTERM') do
    puts 'exiting'
    exit
end

while true do
    begin
        puts "Polling Twitter"
        request = Net::HTTP::Post.new(address.request_uri)
        request.set_form_data(payload)

        #Initialize a Twitter search
        res = Twitter.search(twitter_search, :count => 100, :result_type => "recent").results 
        puts "Retrieved #{res.count} tweets"
        for i in 0...res.count
            # add row to tweets table in database danidb
            if res[i].id > Tweet.maximum("tweet_id")
                tweet = Tweet.create!(message: res[i].text, tweet_id: res[i].id)
                puts tweet.message
                puts tweet.tweet_id

                #calls ua
                response = http.request(request)
                puts response.code
            end
        end
        STDOUT.flush
        sleep 10
    rescue SystemExit, Interrupt # purposeful quit, ctrl-c, kill signal etc
        puts "Stopping"
        raise
    rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
        retry
    end
end



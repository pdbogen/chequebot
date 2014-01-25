#!/usr/bin/env ruby

require 'rubygems'
require 'logger'
require 'twitter'

$stdout.sync = true

logger = Logger.new( $stdout )

logger.info "Starting up..."

load 'db.rb'

Db.new( logger )

if !ENV[ "TWITTER_CK" ] || !ENV[ "TWITTER_CS" ] || !ENV[ "TWITTER_AT" ] || !ENV[ "TWITTER_AS" ]
then
	logger.fatal( "Missing Twitter API keys. Make sure TWITTER_CK, TWITTER_CS, TWITTER_AT, and TWITTER_AS are set in the environment." );
	exit 1
end

rest_client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV[ "TWITTER_CK" ]
	config.consumer_secret     = ENV[ "TWITTER_CS" ]
	config.access_token        = ENV[ "TWITTER_AT" ]
	config.access_token_secret = ENV[ "TWITTER_AS" ]
end

#while true
	followers = rest_client.followers( { :skip_status => 1 } )
	followers.each do |follower|
		if user = Db::User.get( follower.id )
		then
			logger.info( "Old follower: %p" % [ follower.name ] )
		else
			logger.info( "New follower: %p, %p" % [ follower.id, follower.name ] )
			Db::User.create( :id => follower.id );
		end
	end
#	sleep(1)
#end

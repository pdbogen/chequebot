#!/usr/bin/env ruby

require 'rubygems'
require 'logger'

$stdout.sync = true

require './config.rb'
require './db.rb'
require './twitter.rb'
load 'resource.rb'

class Chequebot

	include ChequebotConfig

	def initialize
		@logger = Logger.new( $stdout )
		@logger.info "Starting up..."
		ChequebotDB.new( @logger )
		@twitter = Twitter.new
	end

	def run
		while true
			begin
				runOnce
			rescue RateLimitException
				logger.debug "FIXME: sleep until rate limit renews"
			end
		end
	end

	def runOnce
		followAndGreetNewFollowers
		scanNewMentions
	end

	def followAndGreetNewFollowers
		@twitter.followers().each do |follower|
			if user = ChequebotDB::User.get( follower.id )
			then
				@logger.debug( "Old follower: %p" % [ follower.name ] )
			else
				@logger.info( "New follower: %p, %p" % [ follower.id, follower.name ] )
				user = ChequebotDB::User.create( :id => follower.id )
				if not user.followed
				then
					@logger.info( "Following %p..." % [ follower.name ] )

					# Only follow/DM me in development
					if Config::production? or follower.id==15744114
					then
						@twitter.follow!( follower.id )
						@twitter.dm( follower.id, $msg_welcome_user )
					else
						@logger.info( "Not actually following %p, running in non-prod" % [ follower.name ] )
					end

					user.followed = true
					user.save
				end
			end
		end
	end

	def scanNewMentions
		@twitter.mentions( ChequebotDB::Mention.max( :tweetId ) ).each do |mention|
			logger.debug "%p" % [mention]
		end
	end
end

chequebot = Chequebot.new
chequebot.runOnce

#while true
#	followers = rest_client.followers( { :skip_status => 1 } )
#	followers.each do |follower|
#		if user = ChequebotDB::User.get( follower.id )
#		then
#			@logger.debug( "Old follower: %p" % [ follower.name ] )
#		else
#			@logger.info( "New follower: %p, %p" % [ follower.id, follower.name ] )
#			user = ChequebotDB::User.create( :id => follower.id )
#		end
#		if not user.followed
#		then
#			@logger.info( "Following %p..." % [ follower.name ] )
#
#			# Only follow/DM me in development
#			if CBConfig::production? or follower.id==15744114
#			then
#				rest_client.follow!( follower.id )
#				rest_client.create_direct_message( follower.id, $msg_welcome_user )
#			else
#				@logger.info( "Not actually following %p, running in non-prod" % [ follower.name ] )
#			end
#
#			user.followed = true
#			user.save
#		end
#	end
#	sleep(1)
#end

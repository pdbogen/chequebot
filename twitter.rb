require 'twitter'

class Chequebot
	class Twitter
		include ChequebotConfig
		def initialize
			raise "consumer key missing" unless Config::twitterCK
			raise "consumer secret missing" unless Config::twitterCS
			raise "access token missing" unless Config::twitterAT
			raise "access token secret missing" unless Config::twitterAS

			@rest_client = ::Twitter::REST::Client.new do |config|
				config.consumer_key        = Config::twitterCK
				config.consumer_secret     = Config::twitterCS
				config.access_token        = Config::twitterAT
				config.access_token_secret = Config::twitterAS
			end
		end
		def followers
			@rest_client.followers( { :skip_status => 1 } )
		end
		def follow!( id )
			@rest_client.follow!( id )
		end
		def dm( id, msg )
			@rest_client.create_direct_message( id, msg )
		end
		def mentions( since )
			puts "%p" % [ since ]
			if since.nil?
			then
				@rest_client.mentions_timeline( :count => 200, :trim_user => 1 } )
			else
				@rest_client.mentions_timeline( :since_id => since, :count => 200, :trim_user => 1 } )
			end
		end
		class RateLimitException < Exception
		end
	end
end

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
			@user = @rest_client.user( { :skip_status => 1 } )
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
			result = []
			batch = @rest_client.mentions_timeline( { :since_id => since, :count => 200, :trim_user => 1 } )
			while batch.count > 0
				result.concat( batch );
				batch = @rest_client.mentions_timeline( { :since_id => since, :max_id => batch[0].id, :count => 200, :trim_user => 1 } )
			end
			logger.debug( "found %p new mentions since tweet ID %p" % [ result.count, since ] )
			return result
		end

		def screen_name
			@user.screen_name
		end
		class RateLimitException < Exception
		end
	end
end

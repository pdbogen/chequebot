module ChequebotConfig
	module Config
		@@environment = (ENV["environment"] ? ENV["environment"] : :development)
		@@databaseURL = ENV["DATABASE_URL"]
		@@twitterCK   = ENV["TWITTER_CK"]
		@@twitterCS   = ENV["TWITTER_CS"]
		@@twitterAT   = ENV["TWITTER_AT"]
		@@twitterAS   = ENV["TWITTER_AS"]

		def self.twitterCK
			@@twitterCK
		end

		def self.twitterCS
			@@twitterCS
		end

		def self.twitterAT
			@@twitterAT
		end

		def self.twitterAS
			@@twitterAS
		end

		def self.databaseURL
			@@databaseURL
		end

		def self.environment
			@@environment
		end

		def self.production?
			return @@environment == :production
		end
	end
end

require 'rubygems'
require 'data_mapper'
require 'dm-migrations'

require './model.rb'

class ChequebotDB
	include DataMapper
	include ChequebotDataModel
	include ChequebotConfig

	def initialize( logger )
		raise "no database URL set" unless Config::databaseURL

		DataMapper::Logger.new( $stdout, :debug )
		DataMapper.setup( :default, Config::databaseURL )

		# Prefix db tables with the environment. Whee, isolation!
		DataMapper.repository( :default ).adapter.resource_naming_convention = lambda do |value|
			String(Config::environment) + "_" + DataMapper::NamingConventions::Resource::UnderscoredAndPluralized.call(value)
		end

		load 'model.rb'
		DataMapper.finalize

		# In production, keep DB persistent. Otherwise, wipe out the DB on each run.
		if Config::production?
		then
			DataMapper.auto_upgrade!
		else
			DataMapper.auto_migrate!
		end

		logger.info "Database setup complete"
	end
end

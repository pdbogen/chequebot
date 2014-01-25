require 'rubygems'
require 'data_mapper'
require 'dm-migrations'

class Db
	include DataMapper
	def initialize( logger )
		if ! ENV[ "DATABASE_URL" ]
		then
			logger.fatal "Cannot start: No DATABASE_URL set in environment"
			exit 1
		end
		DataMapper::Logger.new( $stdout, :debug )
		DataMapper.setup( :default, ENV[ "DATABASE_URL" ] )
		load 'model.rb'
		DataMapper.finalize
		DataMapper.auto_upgrade!
		logger.info "Database setup complete"
	end
end

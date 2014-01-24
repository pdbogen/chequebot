#!/usr/bin/env ruby

require 'rubygems'
require 'data_mapper'
require 'logger'

DataMapper::Logger.new($stdout, :debug)
logger = Logger.new( STDOUT )

logger.info "Starting up..."

if ! ENV[ "DATABASE_URL" ]
then
	logger.fatal "Cannot start: No DATABASE_URL set in environment"
	exit 1
end

logger.info "Database URL is there..."

#!/usr/bin/env ruby

require 'rubygems'
require 'data_mapper'
require 'logger'

DataMapper::Logger.new($stdout, :debug)
logger = Logger.new( STDOUT )

if ! ENV[ "DATABASE_URL" ]
then
	logger.fatal "Cannot start: No DATABASE_URL set in environment"
	exit
end

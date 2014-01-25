#!/usr/bin/env ruby

require 'rubygems'
require 'logger'

logger = Logger.new( STDOUT )

logger.info "Starting up..."

load 'db.rb'

Db.new( logger )

while true
	sleep(1)
end

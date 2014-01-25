#!/usr/bin/env ruby

require 'rubygems'
require 'logger'

$stdout.sync = true

logger = Logger.new( $stdout )

logger.info "Starting up..."

load 'db.rb'

Db.new( logger )

while true
	sleep(1)
end

#! /data/data/com.termux/files/usr/bin/ruby

require 'pp'
require "./models/quote.rb"
require "./models/app.rb"

puts "Begin Om lamguage interpreter"

nargs = ARGV.length
puts "number of arguments: #{nargs}"
app = App.new

case nargs
when 0
  puts "Om interactive interpreter:"
	puts "automatically load std.om"
	app.eval_file( "./om/std.om" )

	prompt = "om> "
	print prompt

	while (om_code = gets) != "" do
    q = Quote.new( om_code )
		app.dot( q )

		puts
		print prompt
  end
else
  ARGV.each { |filename| app.eval_file( filename) }
end

puts "End Om lamguage interpreter"

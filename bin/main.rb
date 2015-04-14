require_relative '../lib/objects.rb'
require_relative '../lib/matrix.rb'

if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  x_size = ARGV[0].to_i
  y_size = ARGV[1].to_i
  total_length = x_size * y_size
end

strawb_array = Array.new(total_length)

require_relative 'objects.rb'

# converts a 1-D array to a 2-D array
def array_to_matrix(single_array)
end

# converts a 2-D array to a 1-D array
def matrix_to_array(double_array)
end

if ARGV.length != 2
  puts "ERROR: Need 2 inputs for x and y values of array"
  exit
else
  array_length = ARGV[0]
  array_width = ARGV[1]
end

strawb_array = Array.new()

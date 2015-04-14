module Matrix
  # Find 2-D coordinates of 1-D array. Returns coordinates in an array
  def array_to_matrix(single_array, location)
  end

  # Draw a sample line in the matrix
  # def Matrix.draw_sample_line(length)
  #   (0..length).each do
  #     print " + "
  #   end
  #   puts "\n"
  # end
  #
  # Display the matrix in ASCII format based on length and width
  # def Matrix.draw_sample_matrix(x_size, y_size)
  #   (0..y_size).each do
  #     draw_sample_line(x_size)
  #   end
  # end

  # Draw a line based on a given matrix
  def Matrix.draw_line(array)
    array.each do |elem|
      print elem
      print " "
    end
    puts "\n"
  end

  # Draw a 1-D matrix in 2-D
  def Matrix.draw_matrix(array, x_size, y_size)
    copied_array = Array.new(array)
    (0..y_size - 1).each do |i|
      to_print = copied_array.take(x_size)
      draw_line(to_print)
      copied_array.shift(x_size)
    end
    if !copied_array.empty?
      puts "ERROR: Entire matrix was not drawn"
    end
  end

end

#!/usr/bin/env ruby

unless ARGV[0] == '-all'
  puts 'Please specify -all to convert all jpgs from the current dir'
end

# cjpeg best options
options = '-quality 95 -optimize'

total_saved_size = 0

files_to_convert = Dir["*.jpg"]

# create an opt dir
`mkdir opt`

files_to_convert.each do |file_name|
  next if File.extname(file_name) != '.jpg'

  file_base_name = File.basename(file_name, '.jpg')

  # Convert the jpeg into BMP
  `djpeg #{file_base_name}.jpg > #{file_base_name}_temp.bmp`

  # Convert the BMP into optimized
  `cjpeg #{options} #{file_base_name}_temp.bmp > opt/#{file_base_name}.jpg`

  # Remove BMP
  `rm #{file_base_name}_temp.bmp`

  puts "* optimized: #{file_name}"
  saved_size = (File.size(file_name) - File.size("opt/#{file_base_name}.jpg")) / 1024
  total_saved_size += saved_size
  puts "- saved: #{saved_size} KB"
end

puts "** Total saved: #{total_saved_size} KB"

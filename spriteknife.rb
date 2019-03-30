#!/usr/bin/env ruby

require "mini_magick"
require "fileutils"

abort("Need sheet to slice and pixel size") unless ARGV.count == 2

sheet = MiniMagick::Image.open(ARGV[0])
sprite_size = ARGV[1].to_i
abort("Uneven slice") unless sheet.width % sprite_size == 0 && sheet.height % sprite_size == 0
output_path = "#{ARGV[0].split('.').first}.atlas"
FileUtils.remove_dir(output_path, force: true)
Dir.mkdir output_path
(0...sheet.width / sprite_size).each do |x|
  (0...sheet.height / sprite_size).each do |y|
    cell = MiniMagick::Image.open(ARGV[0])
    cell.crop "#{sprite_size}x#{sprite_size}+#{x*sprite_size}+#{y*sprite_size}"
    last = nil
    skip = true
    cell.get_pixels.each do |row|
      row.each do |col|
        last = col if last == nil
        if last != col
          skip = false
        end
      end
    end
    cell.write "#{output_path}/#{x}#{y}.png" unless skip
  end
end

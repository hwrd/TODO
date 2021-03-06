#!/usr/bin/env ruby -w

require 'date'
require 'fileutils'

date      = Date.today # ISO 8601 Format
filename  = "#{date.year}/#{date}.md"
dirname   = File.dirname(filename)

ignored_files = ["README.md"]

prev_date = Date.parse(Dir["**/*.{md,txt}"].reject{|f| ignored_files.include?(f) }.map{|f| File.basename(f, ".*")}.sort_by {|f| Date.parse(f)}.last)
prev_filename = "#{prev_date.year}/#{prev_date}.md"

UNFINISHED_REGEX = /(?<=## TODO\n)(.|\n)+(?=\n## Accomplished)/
unfinished = File.open(prev_filename, 'r').read.match(UNFINISHED_REGEX) || ""

template = <<-TEMPLATE
# #{date.strftime("%F (%a)")}

## TODO
#{unfinished.to_s.chomp}

## Accomplished

## Notes
TEMPLATE

unless File.directory?(dirname)
  FileUtils.mkdir_p(dirname)
end

File.open(filename, 'w') {|f| f.write(template) }

#!/usr/bin/env ruby -w

require 'date'

date      = Date.today # ISO 8601 Format
filename  = "#{date.year}/#{date}.md"

ignored_files = ["README.md"]

prev_date = Date.parse(Dir["**/*.{md,txt}"].reject{|f| ignored_files.include?(f) }.map{|f| File.basename(f, ".*")}.sort_by {|f| Date.parse(f)}.last)
prev_filename = "#{prev_date.year}/#{prev_date}.md"

UNFINISHED_REGEX = /(?<=## TODO\n)(.|\n)+(?=\n## Accomplished)/
unfinished = File.open(prev_filename, 'r').read.match(UNFINISHED_REGEX) || ""

template = <<-TEMPLATE
# #{date}

## TODO
#{unfinished.to_s.chomp}

## Accomplished

## Notes
TEMPLATE

File.open(filename, 'w') {|f| f.write(template) }

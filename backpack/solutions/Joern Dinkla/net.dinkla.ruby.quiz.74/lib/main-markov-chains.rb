#!/usr/local/bin/ruby -w

require 'getoptlong'
require 'story-generator'
require 'markov-chain'
require 'words'

# Prints out the synopsis.
#
def synopsis()
  puts "ruby main-markov-chains.rb [--help] [--number_of_words N|-n N] [--width W|-w W] [--verbose|-v] [--order O|-O o] textfiles"
end

# these ugly global variables are used for printing out the progress
LOG_FILE_READ_NUM = 1000
LOG_WORDS_NUM = 100

# command line option 
$VERBOSE = nil
$NUMBER_OF_WORDS = 100
$WIDTH = 78
$ORDER = 1

opts = GetoptLong.new(
  ["--help", "-h", GetoptLong::NO_ARGUMENT ],
  ["--number_of_words", "--num", "-n", GetoptLong::REQUIRED_ARGUMENT ],
  ["--order", "--ord", "-o", GetoptLong::REQUIRED_ARGUMENT ],
  ["--width", "-w", GetoptLong::REQUIRED_ARGUMENT ],
  ["--verbose", "-v", GetoptLong::NO_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
  when "--help"
    synopsis()
    exit(0)
  when "--number_of_words"
    $NUMBER_OF_WORDS = Integer(arg)
  when "--verbose"
    $VERBOSE = true
  when "--width"
    $WIDTH = Integer(arg)
  when "--order"
    $ORDER = Integer(arg)
  end 
end

files = ARGV

if files.length() == 0
  STDERR.puts("Error: Missing argument")
  synopsis()
  exit(1)
end

# main
# our story generator
sg = StoryGenerator.new(order = $ORDER)
# feed all the files into it
files.each do |file|
  sg.add_file(file)
end  

# calculate the probabilities
if ( $VERBOSE )
  puts "Calculating probabilities ..."
  STDOUT.flush()
end
sg.mc.recalc_all()

# generate the story
if ( $VERBOSE )
  puts "Generating..."
  STDOUT.flush()
end
story = sg.story($NUMBER_OF_WORDS)

# and print it out formatted
index = 0
last = 0
space = 0
while index < story.length()
  # remember the last non word element
  space = index if ( story[index, 1] =~ /[ ,:;!?.]/ );
  if (index - last == $WIDTH )
    raise "There is a word larger then the width" if ( last == space+1 )
    puts story[last..space]
    index = space
    last = space + 1
  end
  index += 1
end
puts story[last..-1]

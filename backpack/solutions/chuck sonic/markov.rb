#!/usr/bin/env ruby

require 'ArrayExtras'

# 2nd order markov chain for word generation
# this is an exercise in quick-n-dirty, not at pretty code
# chuck.sonic@gmail.com

class Markov
  # just for debugging
  attr_reader :table

  def initialize()
    @table = {}
  end

  def scan_text(filename)
    word1 = nil
    word2 = nil
    scanning = true

    File.open(filename) do |file|
      words = file.each_line do |line|
        if (scanning)
          # looking for START token
          if (line =~ /^\*\*\* START/)
            scanning = false
            word1 = nil
            word2 = nil
          end
          # don't process, just get next line
          next
        end
        if(line =~ /^\*\*\* END/) 
          # this file is done
          scanning = true
          next
        end
        #if we get here, then this is the body
        line.split.each do |curword|
          if(word1.nil? || word2.nil?)
            # getting warmed up, shift and continue
            word1, word2 = word2, curword
            next
          end
          # does the top level table have the root word?
          @table[word1] = {} unless @table.has_key?(word1)
          level1 = @table[word1]
          # does the 2nd level table have the second word?
          @table[word1][word2] = {} unless @table[word1].has_key?(word2)
          # is this a legit increment/init idiom? perhaps...
          @table[word1][word2][curword] = 
            (@table[word1][word2][curword] || 0) + 1
          word1, word2 = word2, curword
        end
      end
    end
    @table.length
  end

  def generate(numwords=120)
    word1 = @table.keys.anyone
    word2 = @table[word1].keys.anyone
    print "#{word1} #{word2} "
    (numwords-2).times do |num|
      arr = @table[word1][word2].to_a
      entry = arr.random(:last)
      word1, word2 = word2, entry.first
      print "#{word2} "
      print "\n" if num%10 == 8
    end
    print "\n"
    nil
  end
end

if __FILE__ == $0
  numwords = 100
  if(ARGV.size >= 2 and ARGV[0] == '-n')
    ARGV.shift
    numwords = ARGV.shift.to_i
    numwords = 100 unless numwords > 0
  end

  unless ARGV.size >=1 
    puts "Usage: #$0 [-n  NUMWORDS] gutenberg1.txt [gutenberg2.txt ...]"
    exit
  end

  m = Markov.new
  ARGV.each do |filename| 
    puts "Scanning file #{filename}..."
    m.scan_text(filename)
  end
  puts "\nHere is your own #{numwords} word story:\n\n"
  m.generate(numwords)
end



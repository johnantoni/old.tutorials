# Author: Shane Emmons
#
# Quiz 74: Markov Chains
#
# This is a bug fix and enhancement to my previous solution.
# Originally this was a recreation of the Mark V. Shaney program.
# However, after extensive work it is something new. You can now
# choose how many words can be stored as a phrase (the default
# is 2). I have also stopped storing Hash keys in reverse order
# since it was hindering debugging. In doing this, I found other
# problems in the selection of words which is now fixed. If you
# see anything that is to wordy, wrong, or can be Rubified let
# me know.
#
# I was thinking, but have not tried, what would happen if you
# sent source code through the algorithm? Obviously some things
# would need to be changed for "phrase_breaks", but I wonder if
# anything would actually sucessfully run.

class MarkovChain

    def initialize( book, max_phrase_size = 2 )
        @book = book
        @phrases = Array.new( max_phrase_size )
        @phrases.each_index { |i| @phrases[ i ] = Hash.new }
        @phrase_breaks = Array.new
    end

    def read( book = @book )
        prev = Array.new( @phrases.length ).fill( '' )
        words = File.open( book ).read.split
        words.each do |word|
            word.gsub!( /["()]/, '' )
            unless prev[ -1 ].eql?( '' )
                @phrases.each_index do |i|
                    prev_words = prev[ @phrases.length - i .. prev.length - 1 ].join( '' )
                    @phrases[ i ][ prev_words ] = Array.new unless
                        @phrases[ i ].has_key?( prev_words )
                    @phrases[ i ][ prev_words ] << word.downcase
                    @phrase_breaks << prev_words if prev_words.match( /[.!?]$/ )
                end
            end
            prev.shift and prev.push( word )
        end
    end

    def get_chain( num_want = 5 )
        chain = Array.new
        num_made = 0
        prev = Array.new( @phrases.length ).fill( '' )
        prevs = Array.new( @phrases.length )
        prev.each_index do |i|
            prevs[ i ] = prev[ @phrases.length - i .. prev.length - 1 ].join( '' )
        end
        while num_made < num_want do
            found = false
            @phrases.each_index do |i|
                found = true if @phrases[ i ].has_key?( prevs[ i ] )
            end
            until found
                prev = @phrase_breaks[ rand( @phrase_breaks.length ) ].split
                prev << '' until prev.length == @phrases.length
                prev.each_index do |i|
                    prevs[ i ] = prev[ @phrases.length - i .. prev.length - 1 ].join( '' )
                end
                @phrases.each_index do |i|
                    found = true if @phrases[ i ].has_key?( prevs[ i ] )
                end
            end
            words = Array.new
            @phrases.each_index do |i|
                prev_words = prev[ @phrases.length - i .. prev.length - 1 ].join( '' )
                words = @phrases[ i ][ prev_words ] if
                    @phrases[ i ].has_key?( prev_words )
            end
            word = words[ rand( words.length ) ]
            chain << word
            prev.shift and prev.push( word )
            prev.each_index do |i|
                prevs[ i ] = prev[ @phrases.length - i .. prev.length - 1 ].join( '' )
            end
            num_made += 1 if word.match( /[.!?]$/ )
        end
        chain
    end

end

mChain = MarkovChain.new( ARGV[ 0 ] )
mChain.read
print mChain.get_chain.join( ' ' ), "\n"

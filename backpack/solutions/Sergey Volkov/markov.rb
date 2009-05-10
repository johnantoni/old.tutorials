#
## Sergey Volkov
## Ruby Quiz #74 - Markov Chain
#
## Very straightforward implementation of Markov Chain Engine.
## MCE object is populated with sequence of items using MCE#<<;
## MCE#gen methods generates next random item based on Markov Chain
## model for collected items;
## To clean internal history, use
##   MCE#input_history.clean (next MCE#<< starts new chain);
##   MCE#output_history.clean (next MCE#gen returns first element in chain);
#
## Quiz solution creates two MCE objects with order 3 and
## populates them with 'word chars' and 'word strings' from input.
## Spaces (\s+) are used to separate words.
#
## Each MCE object is then used to generate 32 words + words to complete
## sentence, and print them using very simple line formatting;
#
## SRAND env var, if set, is used to re-set rand function to allow
## reproduce the same result.
#
## Sample output generated from "The Hound of the Baskervilles"
## by Arthur Conan Doyle (http://www.gutenberg.org/dirs/etext01/bskrv11.txt)
## presented at the end.
#

#
## Helper object: limited length list
class ListN < Array
    attr_reader :max_length
    def initialize( maxlen )
        @max_length = maxlen.to_i
    end
    def << e
        super
        shift while size > @max_length
        self
    end
end

#
## Markov Chain Engine
class MCE
    # order specifies max history length
    def initialize( order=2 )
        @history_continuations = Hash.new{ |h,k| h[k] = Hash.new(0) }
        @input_history  = ListN.new order
        @output_history = ListN.new order
        @items = Hash.new(0)
    end
    #
    ## Readers
    attr_reader :input_history, :output_history, :items
    def order
        @input_history.max_length
    end
    #
    ## Add new item;
    ## increments history continuation counter for the given item,
    ## adds item to the history;
    def << item
        @history_continuations[ @input_history.dup ][ item ] += 1
        @input_history << item
        @items[ item ] += 1
        self
    end
    #
    ## Generate next item based on the current history;
    def gen
        until @output_history.empty? || @history_continuations.key?( @output_history )
            @output_history.shift
        end
        # history contunuation counters table
        contunuations = @history_continuations[ @output_history ]
        # number of all possible continuations
        r = contunuations.values.inject(0){ |sum, val| val+sum }
        # select random continuation (key from hash)
        r, item = rand(r), nil
        contunuations.each{ |key, val|
            if (r -= val) < 0
                # add item to output history
                @output_history << ( item = key )
                break
            end
        }
        item
    end
end

if $0 == __FILE__
# use srand to reproduce result
puts "SRAND=#{SRAND}" if SRAND = ENV["SRAND"]
# use default input file ./bskrv11.txt if it exists
ARGV << "bskrv11.txt" if ARGV.empty? && File.exist?( "bskrv11.txt" )
txtsrc = ARGV[0]||'STDIN'

#
## read text from file if given, $stdin otherwise
text = ARGF.read.chomp!
puts "=== Input from #{txtsrc}: #{text[0..9]}.. [#{text.size}]
..#{text[-10..-1]}"

#
## min number of words to generate;
## complete sentence and stop output after this number of words;
$words_to_generate = 32

#
## simple formatter helper
$line_width=72
class << $stdout
    def puts *args
        super
        @col = 0
    end
    def putw word
        word = word.to_s
        @col ||= 0
        if @col + (@col>0?1:0) + word.size >= $line_width
            self.puts if @col>0 # line break
        elsif @col > 0
            self.print ' '
            @col += 1
        end
        self.print word
        @col += word.size
    end
    attr_reader :col
end
# redefine Kernel methods
# (default implementation does not work - why?)
def putw *args
    $stdout.putw( *args )
end
def puts *args
    $stdout.puts( *args )
end

#
## build MCE for characters
mce = MCE.new( 3 )
ccnt = 0
## collect all word characters
text.scan( /\S+/ ){ |w|
    ccnt += w.size+1
    w.each_byte{ |b| mce << b }
    mce << ?\  # add space as word separator
}

puts "=== #{ccnt} chars collected"
word, n = '', $words_to_generate
srand SRAND.to_i if SRAND
while ch = mce.gen # get next char from MCE
    unless ch == ?\  # word collected
        word << (ch = ch.chr)
        next
    end
    putw word
    n -= 1
    if word =~ /[.!?]$/ && n <= 0
        puts unless $stdout.col == 0
        break
    end
    word = ''
end
mce = nil # free memory
puts "==="

#
## build MCE for words
mce = MCE.new( 3 )
wcnt = 0
## collect all words
text.scan( /\S+/ ){ |w|
    w.gsub!( /["(\[\])"]/, '' )
    unless w.empty?
        wcnt += 1
        mce << w
    end
}

puts "=== #{wcnt} words collected"
n = $words_to_generate
srand SRAND.to_i if SRAND
while word = mce.gen # get word char from MCE
    putw word
    n -= 1
    if word =~ /[.!?]$/ && n <= 0
        puts unless $stdout.col == 0
        break
    end
end
mce = nil
puts "==="

end

__END__
#
## Sample execution log:
$ SRAND=200604 ruby -w MCEngine.rb bskrv11.txt
SRAND=200604
=== Input from bskrv11.txt: The Hound .. [329000] .. the way?"
=== 316203 chars collected
The and to have then morning swate is seems fronelividented to Lond
able prom dogs on the new the clock was I could I could stops the it,
he mon; burge. And deceivated the into the on helped.
===
=== 59140 words collected
The Hound of the Baskervilles was not extinct in this their last
representative. Meanwhile, said he, I have hardly had time to answer,
Baskerville seized me by the hand and wrung it heartily.
===


# 

require 'markov-chain'

# A generator for stories. Fill the Markov chain with the methods add()
# or add_file() and generate a story with the method story().
#
class StoryGenerator

  attr_reader :mc, :order
  
  # Initializes.
  #
  def initialize(order = 1) 
    @mc ||= MarkovChain.new(order = order)
    @order = order
  end

  # Adds the words to the MarkovChain
  #
  def add(words) 
    @mc.add_elems(words)
  end

  # Adds a file to the MarkovChain.
  #
  def add_file(file) 
    puts "Reading file #{file}" if ( $VERBOSE )
    words = Words.parse_file(file)
    if ( $VERBOSE )
      puts "Read in #{words.length} words."
      puts "Inserting words from file #{file}"
      STDOUT.flush()
    end
    @mc.add_elems(words)
  end
  
  # Genereates a story with n words (".", "," etc. counting as a word) 
  #
  def story(n, initial_words = nil)
    elems = generate(n, initial_words)
    format(elems)
  end
  
  # Generates a story from the Markov Chain mc of length n and which starts with a
  # successor of word.
  #
  def generate(n, words)
    lexicon = @mc.nodes()
    words = random_word(lexicon) if words.nil?
    elems = []
    1.upto(n) do |i|
      next_word = @mc.rand(words)
      # if no word is word, take a random one from the lexicon
      if next_word.nil?
        words = random_word(lexicon)
      else
        if 1 == @order 
          words = next_word
          elems << words
        else
          elems << words.shift()
          words.push(next_word)
        end
      end
      if ( i % LOG_WORDS_NUM == 0 && $VERBOSE )
        puts "Generated #{i} words." 
        STDOUT.flush()
      end
    end
    elems
  end
  
  # Formats the elements.
  #
  def format(elems)
    text = elems.join(" ")
    text.gsub!(/\ ([.,!?;:'"-])\ /, '\1 ')
    text
  end

  # Returns a random (list of) word(s)
  #
  def random_word(lexicon)
    lexicon[rand(lexicon.length)]  
  end
  
end

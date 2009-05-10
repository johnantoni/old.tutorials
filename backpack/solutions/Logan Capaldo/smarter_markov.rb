require 'markov2'
class SmarterMarkovChainBuilder < MarkovChainBuilder
  def initialize(src)
    super(src, /\s+/, /\S+/, false)
  end
  def markov_chain(initial_word, len = 10)
    initial_chain = super
    index_of_last_word = nil
    initial_chain.each_index do |idx|
      if initial_chain[idx] =~ /\.|\?|!/
        index_of_last_word = idx
        break
      end
    end
    if index_of_last_word
      initial_chain[0..index_of_last_word]
    else
      initial_chain
    end
  end
end
if $0 == __FILE__
  mc = nil
  File.open(ARGV[0]) do |file|
    mc = SmarterMarkovChainBuilder.new(file)
  end
  start_words = mc.words.select { |w| w =~ /^[A-Z]/ }
  init_word = start_words[ rand(start_words.length) ]
  puts mc.markov_chain(init_word, 200).join(' ').gsub(/"/,'')
end

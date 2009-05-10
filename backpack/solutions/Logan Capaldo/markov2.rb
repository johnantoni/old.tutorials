class MarkovChainBuilder
  class Entry < Struct.new(:word_index, :successors)
  end
  def initialize(src, separator = /\W+/, word_shape = /\w+/, downcase = true)
    @src = src
    @separator = separator
    @word_shape = word_shape
    @downcase = downcase
    build_tables
  end
  def build_tables
    @word_list = []
    @successor_lists = {}
    last_word = nil
    @src.each do |line|
      line = line.downcase if @downcase
      line = line.chomp
      words_for_line = line.split(@separator).select{ |w| w.match(@word_shape)}
      words_for_line.each do |word|
        unless @successor_lists.has_key? word
          entry = @successor_lists[word] = Entry.new
          @word_list << word
          entry.word_index = @word_list.length - 1
          entry.successors = []
        end

        unless last_word.nil?
          @successor_lists[last_word].successors << @successor_lists[word].word_index
        end
        last_word = word
      end
    end
  end
  def distributed_successors_for(word)
    @successor_lists[word].successors.map { |index| @word_list[index] }
  end
  def randomized_next_for(word)
    succs = distributed_successors_for(word)
    succs[ rand(succs.length) ]
  end
  def markov_chain(initial_word, len = 10)
    res = [initial_word]
    (len - 1).times do
      res << randomized_next_for(res.last)
    end
    res
  end
  def words
    @word_list
  end
  private :build_tables
end

if $0 == __FILE__
  if ARGV[0].nil?
    STDERR.puts "Please provide a corpus."
    STDERR.puts "#$0 usage: #$0 <corpus file name> [chain length] [initial word]"
    exit 1
  end
  chain_len = (ARGV[1]  || 10).to_i
  mc = nil

  File.open(ARGV[0]) do |file|
    mc = MarkovChainBuilder.new(file)
  end
  init_word = (ARGV[2] || mc.words[ rand(  mc.words.length )  ] )

  chain = mc.markov_chain(init_word, chain_len)
  puts chain.join(' ').capitalize
end

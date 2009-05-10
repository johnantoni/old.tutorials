class WordTable
  def initialize(src, separator = /\W+/, word_shape = /\w+/)
    @src = src
    @separator = separator
    @word_shape = word_shape
  end

  def build_table
    @table = Hash.new { |h, k| h[k] = [] }
    pos = 0
    while line = @src.gets
      line = line.chomp.downcase
      words = line.split(@separator).select { |potential_word|
        potential_word.match(@word_shape)
      }
      words.each do |word|
        @table[word] << pos
        pos += 1
      end
    end
    self
  end
  def words
    @table.keys
  end

  def positions_for(word)
    @table[word]
  end

  def followers_for(word)
    positions = positions_for(word)
    followers_positions = positions.map { |i| i + 1 }
    following_words = self.words.select { |key_word|
      followers_positions.any? { |pos| positions_for(key_word).include?(pos) }
    }
    following_words
  end
end

class ChainBuilder
  attr_accessor :chain_length
  def initialize(initial_word, word_table, chain_length = 10)
    @initial_word =  initial_word
    @word_table = word_table
    @chain_length = chain_length
  end

  def distributed_followers(word)
    distd_followers = []
    followers = @word_table.followers_for(word)
    positions_of_word = @word_table.positions_for(word)
    followers.each do |follower|
      follower_positions =  @word_table.positions_for(follower)
      count = follower_positions.select { |pos|
        prec =  pos - 1
        positions_of_word.include?(prec)
      }.length
      distd_followers += [follower] * count
    end
    distd_followers
  end
  def randomized_next_word(word)
    choices = distributed_followers(word)
    choices[ rand(choices.length) ]
  end
  def chain
    res_chain = [@initial_word]
    (self.chain_length - 1).times do
      res_chain << randomized_next_word(res_chain.last)
    end
    res_chain
  end
end



if $0 == __FILE__
  if ARGV[0].nil?
    STDERR.puts "Please provide a corpus."
    STDERR.puts "#$0 usage: #$0 <corpus file name> [chain length] [initial word]"
    exit 1
  end
  chain_len = (ARGV[1]  || 10).to_i
  wt = nil

  File.open(ARGV[0]) do |file|
    #wt = WordTable.new(file, //, /./) # try by characters
    wt = WordTable.new(file)
    wt.build_table
  end
  init_word = (ARGV[2] || wt.words[ rand(  wt.words.length )  ] )

  chain_builder = ChainBuilder.new(init_word, wt, chain_len)
  chain = chain_builder.chain
  puts chain.join(' ').capitalize
end

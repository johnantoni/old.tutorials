#!/usr/local/bin/ruby
#
# Run with -h or --help for options.

require 'open-uri'
require 'optparse'

class MarkovEngine
  attr_accessor :chains
  
  def initialize(*filenames)
    @chains = {} 

    filenames.each do |filename|
      if filename && File.exists?(filename)
        @chains.merge! Marshal.load(File.read(filename))
      end
    end

    # we could compress the tree here to just the top
    # scoring match, but that would prevent us using
    # variance and fuzzy matching.
  end

  def learn_from(text, order = 1, weight = 0, sentence_awareness = false)
    weight += 1 if weight
    txt = text.split
    txt.inject(txt.shift) do |prev,word|
      # don't cross sentence boundaries?
      if sentence_awareness && word =~ /[.!?:;]$/
        prev = ""
      else
        oldprevs = prev.split
        plen = [oldprevs.length, order].min
        prev = oldprevs[-plen,plen].join(" ")
      end

      # if plen != order we need to fill up prev a bit more
      if plen == order && word =~ /\w/
        wordsym = word.intern
        prevsym = prev.intern
        
        # compensate for no default proc with either marshal or yaml
        (@chains[prevsym] ||= {})[wordsym] ||= 0
        @chains[prevsym][wordsym] += weight || word.length
      end

      prev << " " << word
    end
    nil
  end

  def select_next(word, max_variance = 0)    
    word = word.to_sym   # may be a sym already
    o = @chains[word] || {}
    poss = o.inject([0,[]]) do |(score,words),(k,v)|      
      variance = rand(max_variance)
      if v > score - variance
        [v,[k]]
      elsif v == score - variance
        [score,words << k]
      else
        [score,words]
      end
    end.last
    
    r = (poss[rand(poss.length)] || 
         @chains.keys[rand(@chains.keys.length)]).to_s.split.first.to_sym
    
    $stderr.puts "#{word} => #{r} (#{poss.inspect})" if $VERBOSE
    r
  end
  
  def generate_text(wordcount, 
                    start_with = nil, 
                    max_variance = 0, 
                    fuzzy_variance = true, 
                    memory_len = 5)
    word = start_with 
    unless word
      tries = 0
      until word.to_s =~ /^[A-Z]/ || (tries += 1) > 20
        word = @chains.keys[rand(@chains.keys.length)]
      end
    end
    prev = word
    
    # loop for words
    memory = ([nil] * (memory_len - 1)) + [word]  
    txt = ""
    total = (wordcount / 2 + rand(wordcount / 2))    
    total.times do |i|
      txt << " " << word.to_s
      word, prev = fetch_next(prev,memory,max_variance,fuzzy_variance)
      
      # we close to our total? Is this a sentence boundary?
      # quit now if so, we may not get the chance again...
      break if prev.to_s[-1,1] =~ /[\.\!\?]/ and i >= total - 10
    end
    
    txt.chomp!
    txt.lstrip!
    
    # If we didn't manage to finish on a sentence boundary, try a few
    # extra words to see if we can get one.
    extras = 0
    until txt[-1,1] =~ /[\.\!\?]/ or extras > [10,wordcount / 4].max
      txt << " " << word.to_s
      word, prev = fetch_next(prev,memory,max_variance,fuzzy_variance)
      
      txt.chomp!
      extras += 1
    end

    # last ditch
    txt << '.!?'[rand(3)] if txt[-1,1] !~ /[\.\!\?]/
    txt
  end

  def save_to(filename)
    # originally used YAML but there are probs with quoted symbols... :(
    File.open(filename, 'w+') do |f|
      f << Marshal.dump(@chains)
    end
    true
  end

  private

  # helper for generate_text
  def fetch_next(prev,memory,max_variance,fuzzy_variance)
    word = select_next(prev,max_variance)
    tries = 0
    while fuzzy_variance && memory.include?(word) && tries < 4
      word = select_next(prev,max_variance+(tries += 1))
    end
    if memory.include? word
      word = @chains.keys[rand(@chains.keys.length)].to_s.split.first.to_sym
    end
     
    prev = prev.to_s.split
    prev.shift
    prev = (prev << word).join(' ').to_sym

    # Remember this word so we don't get stuck in a cycle
    memory.shift
    memory.push(word)

    [word,prev]   
  end    
end

class MarkovRunner    
  class << self
    def run(opts = ARGV)
      new.run(opts)
    end
  end

  def initialize
    @summary_only = false
    @learn = false
    @store_files = []
    @learn_from = []
    @learn_order = 2
    @learn_weight = 0
    @wordcount = 200
    @max_variance = 1
    @fuzzy_variance = true
    @sentence_breaks = false
    @start_with = nil
    @memory_length = 5
  end
  
  def run(opts)
    parse_opts(opts)
    e = MarkovEngine.new(*@store_files)

    if @summary_only        
      if @store_files.empty?
        puts "Knowledge loaded from: (none)"
      else
        puts "Knowledge loaded from: #{@store_files.inspect}"
      end

      nch = e.chains.length
      puts "#{nch} top-level chains"
      if $VERBOSE
        nln = e.chains.inject(0) { |n,(word,chain)| n + chain.length }        
        puts "#{nln} links"
        puts "Average chain length: #{(nch > 0) ? (nln / nch.to_f) : 'n/a'}"
      end
      order = e.chains.keys[rand(e.chains.keys.length)].to_s.split.length
      puts "Apparent order is   : #{order}"
      
      return 1
    end
      
    if @learn
      if @store_files.length > 1
        $stderr.puts 'warning: multiple store files ignored'
      end
      
      if @learn_from.empty?
        e.learn_from($stdin.read,@learn_order,@learn_weight,@sentence_breaks)
      else
        @learn_from.each do |fn|
          if fn =~ /:\/\//
            e.learn_from(URI(fn).read,@learn_order,@learn_weight,
                         @sentence_breaks)
          elsif File.exists?(fn)
            e.learn_from(File.read(fn),@learn_order,@learn_weight,
                         @sentence_breaks)
          else
            $stderr.puts "warning: unrecognized input: #{fn}"
          end
        end
      end
      e.save_to(@store_files.last)
      0
    else
      # can't generate with an empty engine
      if e.chains.empty?
        $stderr.puts("error: need input")
        1
      else
        puts e.generate_text(@wordcount, 
                             @start_with, 
                             @max_variance, 
                             @fuzzy_variance, 
                             @memory_length)
        0
      end
    end
  end

  private

  def parse_opts(args)
    opts = OptionParser.new do |opt|
      opt.banner = "syntax: ./markov.rb [options]"

      opt.separator ""
      opt.separator "where [options] include:"
      
      opt.on('-f','--file FILENAME',
             'Specify knowledge file to use. More than',
             '  one -f option may be supplied when',
             '  generating text. In learn mode, only the',
             '  last filename specified is recognised.',
             '  (default: chainstore)') do |fn|
        @store_files << fn
      end
      
      opt.on('-w','--words MAXWORDCOUNT',Integer,
             'Set the maximum number of words to',
             "  output. (default: #{@wordcount})") do |count|
        @wordcount = count
      end

      opt.on('-s','--start-with WORDS',
             'Specify one or more (matching order ',
             '  setting) words from which generation',
             '  should begin. (default: random).') do |w|
        @start_with = w
      end
             
      opt.on('-v','--max-variance N',Integer,
             'Set the maximum scoring variance to use',
             '  in generation (higher = fuzzier match,',
             "  default: #{@max_variance})") do |variance|
        @max_variance = variance
      end

      opt.on('-z','--no-fuzzy-variance',
             'Disable variance fuzz when searching for',
             '  next word in generation.') do
        @fuzzy_variance = false
      end
      
      opt.on('-m','--memory-length N',Integer,
             'Set length of the queue used to avoid',
             "  cycles in output. (default: #{@memory_length})") do |length|
        @memory_length = length
      end

      opt.on('-l','--learn [FILEORURI]',
             'Read FILEORURI and learn from it.',
             '  Multiple -l options may be supplied.',
             '  If no file or URI is specified, stdin',
             '  is read.') do |uri|
        @learn = true
        @learn_from << uri if uri
      end        

      opt.on('-b','--sentence-breaks',
             'Enable sentence-break awareness in',
             "  learn mode. (default #{@sentence_breaks})") do |b|
        @sentence_breaks = b
      end
      
      opt.on('-o','--order N',Integer,
             'Set order to N for learn mode. Ignored',
             "  during generation. (default: #{@learn_order})") do |n|
        @learn_order = n
      end

      opt.on('-g','--weight N',
             'Set score weighting for learn mode.',
             '  If weight is "A", word-length weighting',
             '  will be used. (default: 0)') do |weight|
        if weight == "A"
          @learn_weight = nil
        else
          @learn_weight = weight.to_i
        end
      end

      opt.on_tail('-R', '--report','Display knowledge summary') do
        @summary_only = true
      end
      
      opt.on_tail('-V', '--verbose','Enable verbose output on stderr') do
        $VERBOSE = true
      end       

      opt.on_tail('-h','--help','Display this help text') do
        puts opts
        exit(1)
      end
    end

    opts.parse(args)
    if @store_files.empty? and File.exists?('chainstore')
      @store_files << 'chainstore'
    end
  end
end

if $0 == __FILE__
  exit(MarkovRunner.run)
end


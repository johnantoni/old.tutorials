#!/usr/bin/ruby

class MarkovWords

  def initialize(filename, order)
    @order = order
    @words = Hash.new
    @state = Array.new(@order)
    previous = Array.new(@order)
    File.foreach(filename) do |line|
      line.split(/\s+/).each do |word|
        unless previous.include?(nil)
          p = previous.join(' ')
          unless @words.has_key?(p)
            @words[p] = Array.new
          end
          @words[p] << word
        end
        previous.shift
        previous.push(word)
      end
    end
  end

  def print_words(n = 50)
    word = next_word(true)
    1.upto(n) do |i|
      print word, i == n ? "\n" : " "
      word = next_word()
    end
    print "\n"
  end

  # sentences start with a capital or quoted capital and end with
  # punctuation or quoted punctuation
  def print_sentences(n = 5)
    sentences = 0
    word = next_word(true)
    while word !~ /^['"`]?[A-Z]/
      word = next_word()
    end
    begin
      print word
      if word =~ /[?!.]['"`]?$/
        sentences += 1
        if sentences == n
          print "\n"
        else
          print " "
        end
      else
        print " "
      end
      word = next_word()
    end until sentences == n
  end

  def next_word(restart = false)
    if restart or @state.include?(nil)
      key = @words.keys[rand(@words.length)]
      @state = key.split(/\s+/)
    end
    key ||= @state.join(' ')
    # restart if we hit a dead end, rare unless text is small
    if @words[key].nil?
      next_word(true)
    else
      word = @words[key][rand(@words[key].length)]
      @state.shift
      @state.push(word)
      word
    end
  end

end

class MarkovLetters

  def initialize(filename, order)
    @order = order
    @letters = Hash.new
    @state = Array.new(@order)
    previous = Array.new(@order)
    File.foreach(filename) do |line|
      line.strip!
      line << ' ' unless line.length == 0
      line.gsub!(/\s+/, ' ')
      line.gsub!(/[^a-z ]/, '')
      line.split(//).each do |letter|
        unless previous.include?(nil)
          p = previous.join('')
          unless @letters.has_key?(p)
            @letters[p] = Array.new
          end
          @letters[p] << letter
        end
        previous.shift
        previous.push(letter)
      end
    end
  end

  # words begin after a space and end before a space
  def print_words(n = 50)
    letter = next_letter(true)
    while letter != ' '
      letter = next_letter()
    end
    letter = next_letter()
    words = 0
    while words < n
      words += 1 if letter == ' '
      print letter
      letter = next_letter()
    end
    print "\n"
  end

  def next_letter(restart = false)
    if restart or @state.include?(nil)
      key = @letters.keys[rand(@letters.length)]
      @state = key.split(//)
    end
    key ||= @state.join('')
    # restart if we hit a dead end, rare unless text is small
    if @letters[key].nil?
      next_letter(true)
    else
      word = @letters[key][rand(@letters[key].length)]
      @state.shift
      @state.push(word)
      word
    end
  end

end

if $0 == __FILE__
  require 'getoptlong'

  def usage()
    $stderr.puts "Usage: ruby #{$0} [options] <filename>",
                 "  -h, --help         show this usage message",
                 "  -o, --order        set markov chain order",
                 "  -s, --sentences    set number of sentences to print",
                 "  -w, --words        set number of words to print",
                 "  -l, --letters      use letters as the basic unit"
  end

  order = 2
  sentences = 5
  words = nil
  letters = false

  opts = GetoptLong.new(["--help",      "-h", GetoptLong::NO_ARGUMENT],
                        ["--order",     "-o", GetoptLong::REQUIRED_ARGUMENT],
                        ["--sentences", "-s", GetoptLong::REQUIRED_ARGUMENT],
                        ["--words",     "-w", GetoptLong::REQUIRED_ARGUMENT],
                        ["--letters",   "-l", GetoptLong::NO_ARGUMENT])

  opts.each do |opt, arg|
    case opt
    when "--help"
      usage
      exit 0
    when "--order"
      order = arg.to_i
    when "--sentences"
      sentences = arg.to_i
      words = nil
    when "--words"
      words = arg.to_i
      sentences = nil
    when "--letters"
      letters = true
      words = 50 if words.nil?
    end
  end

  if ARGV.length < 1
    usage
    exit 1
  end

  ARGV.each do |arg|
    begin
      if letters
        m = MarkovLetters.new(arg, order)
        m.print_words(words)
      else
        m = MarkovWords.new(arg, order)
        m.print_words(words) unless words.nil?
        m.print_sentences(sentences) unless sentences.nil?
      end
    rescue
      $stderr.puts $!
    end
  end
end


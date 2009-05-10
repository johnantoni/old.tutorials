class String
  def wordwrap(len)
    # method for wrapping text, used for the output
    gsub( /\n/, "\n\n" ).gsub( /(.{1,#{len}})(\s+|$)/, "\\1\n" )
  end
end

class Markov

  def initialize(file)
    # open file, and make hash for storing the text
    @text = Hash.new
    read_text(file)
  end

  def create_paragraph(len)
    # method to generate a paragraph, once text has been read in
    # takes a length, which is the minimum number of words for the 
    # paragraph
    # array to hold the proximal words as scanning along
    scan = Array.new(2,"\n")
    @words = Array.new 
    # keep reading until length has been exceed, and end with a 
    # closing punctuation mark of '.' or '?' or '!'
    flag = 0
    while @words.length <= len || flag == 0
      flag = 0
      # select a random word which is preceeded by the previous two
      # words
      word = random_word(scan)
      # exit if hit end of previous text.
      break if word == "\n"
      flag = 1 if word =~ /[\.\?\!][\"\(\)]?$/;
      # only start slurping words once finish first sentence
      # otherwise the start of the text will always be the same.
      @words.push(word) if @words.length > 0 || flag == 1
      # shift the array to contain the previous two words for the next 
      # round
      scan.push(word).shift
    end
    # remove the first word.  a left over from the opening sentence
    @words.shift
  end
  
  def print_text
    # method to output the paragraph created.  '"' and '(' and ')'
    # are removed, as they are often orphaned in the output text.
    # no attempt is made to quote spoken text in this version.
    print @words.join(" ").gsub(/[\"\(\)]/,"").wordwrap(68)
  end
  
  private
  
  def read_text(file)
    # read the file
    File.open(file) do |f|
      # array to hold the preceeding two words while reading the text
      scan = Array.new(2,"\n")
      while line = f.gets
        line.split.each do |w|
          # call the method which adds the next word to the text hash
          add_text(scan[0], scan[1], w)
        # shift the array to contain the previous two words.
        scan.push(w).shift
        end
      end
      # add a return at the end to mark the end of the text.
      add_text(scan[0],scan[1], "\n")
    end
  end
  
  def random_word(scan)
    # select random word which is preceed by the previous 
    # two words
    index = rand(@text[scan[0]][scan[1]].length)
    return @text[scan[0]][scan[1]][index]
  end
  
  def add_text(a,b,c)
    # method which builds the text hash (a second order word chain)
    # first check whether key exists for first word
    # if so, then check whether keys exists for second word
    # build hash appropriately.  after hash-hash, then build
    # array which contains all words which are proceeded by the
    # previous two.
    if @text.key?(a)
      if @text[a].key?(b)
        @text[a][b].push(c)
      else
        @text[a][b] = Array.new(1,c)
      end
    else
      @text[a] = Hash.new
      @text[a][b] = Array.new(1,c)
    end
  end
  
end

# call script, telling file to process, and the minimum
# length of text to output.

if ARGV[1] == nil
   abort("Usage: markovtext.rb file length")
else
   file = ARGV[0]
   length = ARGV[1].to_i
end

text = Markov.new(file)
text.create_paragraph(length)
text.print_text
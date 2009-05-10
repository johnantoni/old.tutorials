#!/cygdrive/c/ruby/bin/ruby

num_sentences = 10 # number of sentences to output
order = 2   # order: next word depends on n previous words

while ARGV.length > 0 do 
    arg = ARGV.shift
    if arg == '-o'
        order = ARGV.shift.to_i
    elsif arg == '-n'
        num_sentences = ARGV.shift.to_i        
    end
end

# Hash key: string which has the last n words
# value: an array of the next words that are seen in the text given the last n(=order) words in the key
hash = {}
# last_n is an array of the last n words seen while processing the text
last_n = []
# these are the first n words seen
save_first_n = []

# This loop reads from stdin line by line
#
# Some obvious non-text characters are removed.
# Multiple punctuations are also removed. #
# Otherwise, all punctuation is kept.
#
# White space is stripped
ARGF.each_line do |line|
    # When special characters like <> and {} and [] are encountered, they and the contents between them are removed.    
    line.gsub!(/<[^>]*>/,"")
    line.gsub!(/<[^>]*$/,"")
    line.gsub!(/^[^<]*>/,"")
    
    line.gsub!(/\[[^\]]*\]/,"")
    line.gsub!(/\[[^\]]*$/,"")
    line.gsub!(/^[^\[]*\]/,"")
    
    line.gsub!(/\{[^\}]*\}/,"")
    line.gsub!(/\{[^\}]*$/,"")
    line.gsub!(/^[^\{]*\}/,"")
    
    # Also remove multiple consecutive punctuation. 
    # I don't this this is allowed in the english language (except for 3 dots)
    line.gsub!(/[!?|$:;'][!?|$:;']+/,"")
    line.gsub!(/\.\.\.\.+/,"")      # remove more than 4 or more dots
    line.gsub!(/([^.]|^)\.\.($|[^.])/,"") # remove two dots
    
    line.strip!
       
    words = line.split
    words.each do |word|
        word.strip! 
        if last_n.length == order
            # we've accumulated order # of words
            # Now we can store the transition to the next word into our hash
            last_n_str = last_n.join(" ")
            if hash[last_n_str] 
                hash[last_n_str] << word
            else
                hash[last_n_str] = [word]
            end
            # Pop the first element in the last_n queue to make room for the next word 
            last_n.shift
        else
            # Save the first n words this will be our starting seed
            save_first_n << word
        end
        last_n << word        
    end
end

# Initial starting point is the first n words
last_n = save_first_n

print save_first_n.join(" ") + " "

# Print 'num' sentences
# Sentences are ended when a one of "!?." is encountered.
sentence_cnt = 0
while sentence_cnt < num_sentences do
    last_n_str = last_n.join(" ")
    if hash[last_n_str] != nil 
      # Randomly select the next word from the last_n words
      word = hash[last_n_str][rand(hash[last_n_str].length)]
      print word
      if word =~ /[!?.]$/
          # if word contains a "!?." then it is the last word of a sentence
          sentence_cnt += 1
          puts
      else
          print " "
      end
    end
    last_n.shift
    last_n << word    
end


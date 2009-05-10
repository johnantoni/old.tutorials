class MarkovChain
  def initialize(text)
    @words = Hash.new
    wordlist = text.split
    wordlist.each_with_index do |word, index| 
      add(word, wordlist[index + 1]) if index <= wordlist.size - 2
    end
  end

  def add(word, next_word)
    @words[word] = Hash.new(0) if !@words[word]
    @words[word][next_word] += 1
  end

  def get(word)
    return "" if !@words[word]
    followers = @words[word]
    sum = followers.inject(0) {|sum,kv| sum += kv[1]}
    random = rand(sum)+1
    partial_sum = 0
    next_word = followers.find do |word, count|
      partial_sum += count            
      partial_sum >= random
    end.first
    #puts "Selected #{next_word} from #{candidates.inspect}"
    next_word
  end    
end

mc = MarkovChain.new(File.read("Agatha Christie - The Mysterious Affair at Styles.txt"))

sentence = ""
word = "Murder"
until sentence.count(".") == 4
  sentence << word << " "
  word = mc.get(word)
end
puts sentence << "\n\n"

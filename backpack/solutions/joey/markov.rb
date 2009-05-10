class WordHash
  attr_accessor :words
  def initialize(words)
    @words = {}
    words.each_with_index{|x,i|self.add(x,words[i-1],words[i+1])}
  end

  def add(word,prev,nex)
    @words[word] ||= {}
    @words[word]['prev'] ||= Hash.new{|k,v|k[v]=0}
    @words[word]['prev'][prev] += 1
    @words[word]['next'] ||= Hash.new{|k,v|k[v]=0}
    @words[word]['next'][nex] += 1
  end
end
f =  ARGF.read.join.tr('"/*\\()[]\'', ' ').downcase
words = f.gsub(/[^'\w]/, ' \0 ').gsub(/\s+/, ' ').split(/\W/)
words = words.map{|x|x.strip}
w = WordHash.new(words)
@k = (a=w.words).keys[rand(a.size)]
wi = [@k.capitalize]
100.times do
  c=(a=w.words[@k]['next']).keys[rand(a.keys.size)]
  if c != ' '
  wi << c
  @k =  w.words.keys.find{|y|y==c}||rand(a.keys.size)
  else
    next
  end
end
puts wi.join(" ").gsub(/\s+/,' ')+'.'

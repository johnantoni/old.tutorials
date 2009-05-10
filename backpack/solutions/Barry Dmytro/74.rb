#!/usr/bin/env ruby

class Array
	def rand
		self[Kernel::rand(self.size-1)]
	end
end

words = {}

File::open("book.txt") do |f|
	book = f.read.gsub(/\n/,"")
	arr = book.split
	arr.each_with_index do |word,index|
		eos = false
		eos = true if word[word.size-1].chr == "."
		word = word.gsub(/\W/,"").downcase
		words[word] = [] unless words.has_key? word
		if eos == true then
			words[word] << :EOS
		elsif arr.size-1 != index then
			next_word = arr[index+1]
			next_word = next_word.gsub(/\W/,"").downcase
			words[word] << next_word
		else
			words[word] << :EOS
		end
	end
end

word = words.keys.rand
state = word.capitalize
while true
	word = words[word].rand
	break if word == :EOS
	state << " " << word
end
puts state + "."

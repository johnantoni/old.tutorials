require 'enumerator'

ORDER = 3

class Markov
   def initialize
      @graph = Hash.new { |h, k| h[k] = Hash.new(0) }
      @count = Hash.new(0)
   end

   def <<(group)
      source, sink = group[0...-1].join(' '), group[-1]
      @graph[source][sink] += 1
      @count[source] += 1
   end

   def [](group)
      return '' if group.empty?

      source = group.join(' ')
      return self[group[1..-1]] if @count[source].zero?

      x = rand(@count[source])
      @graph[source].each do |sink, freq|
         return sink if x < freq
         x -= freq
      end
   end
end

m = Markov.new

length = 0
number = 0

ARGV.each do |arg|
   puts "Reading: #{arg}"

   words  = [''] * ORDER
   words += File.open(arg).read.split(/\s+/).reject { |x| x.empty? }

   words.each_cons(ORDER+1) do |group|
      m << group
      length += 1
   end
   number += 1
end

text = []
group = [''] * ORDER
(length / number).times { text << group.push(m[group]).shift }

puts text.join(' ')

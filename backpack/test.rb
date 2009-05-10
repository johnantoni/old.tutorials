module Movement
  def run
    puts "running"
  end
end

class Sprinter
  include Movement #using a module as a mixin
  def initialize
    @name = "David"
  end
  def show
    puts "#{val}"
  rescue NoMethodError => e: #no method error
    puts "problem: #{e}"
  rescue Exception: #exception handling
    puts "something broke!"
  end
end
mover = Sprinter.new
mover.run
mover.show 
mover.wow rescue puts "broken wow!" #block exception
    
class Boogeyman 
  DEFER = "ddd" #class constants
  attr_reader :name #read attribute
  attr_writer :name #write attribute
  
  def initialize(name) #init
    @name = name
    @@def2 = name #class variable
  end 

  protected #only available in this object and not
    #anything derived from it / inherited
  def show
    puts 'show something'
    return true
  end
  
  public #accessible outside class
  def show
    puts "#{@@def2}"
  end
  
  private #accessible inside class
#  def name #get
#    puts "Yes, #{@name}?"
#  end
#  def name=(newname) #set
#    @name = newname
#  end
end 
monster1 = Boogeyman.new('john')
monster1.name = 'david'
puts monster1.name # + monster1.DEFER
#puts monster1.show
monster1.show
puts "\n\n"

a = 10 * rand
if a < 5
  puts "#{a} less than 5"
elsif a > 5
  puts "#{a} greater than 5"
end
puts "\n"

#unless is reverse of if"

#case
case a
when 0..5
  puts "0 to 5"
when 6
  puts "six"
else
  puts "#{a}"
end
puts "\n"

#function
def func(a)
  puts "hello #{a}"
  return a.length
end
len = func("sister")
puts "word is #{len} long\n\n"

#block
3.times { puts "hi" }
3.times { |x| puts "loop #{x} <= self value"}

#every time function invokes yield control passes to the block
#control is yielded to the block so it runs twice
def animals
  yield "tiger"
  yield "bat"
end
animals { |x| puts "hello, #{x}" }
#here the function is run twice!

puts "\n\n"

def myeach(myarray) 
  iter = 0 
  while (iter < myarray.length): 
    yield(myarray[iter]) 
    iter += 1 
  end 
end 
testarray = [1,2,3,4,5] 
myeach(testarray) {|item| print "#{item}:"}
puts "\n"
testarray.each do |elem|
  print "elem:#{elem}, "
end

puts "\n\n"
def ampersand(&block) 
  block.call 
  yield #does same as .call in this case 
end 
ampersand { print "I'm gettin' called! " } 

puts "\n\n"
puts "6 = zero? #{6.zero?}"

human = 50..55 #range
puts "is in range of 50-55 #{human == 54}"

puts "crown digital w14 0eh 02073560797"

dogs = [13, 12, 20, "ace"]
p dogs
words = %w( this is cool )
p words
words.push(22)
words << 23
words.insert(-1, 24) #inserts element at specific point
p words
p words[3..5]

p words.pop #out of end
p words.shift #off of beginning
p words
p words.delete_at(1) #remove element at specific place
p words
words.each {|elem| puts " element => #{elem}"}

#blocks are lumps of code
#procs are blocks that are pushed into variables
stuff = Proc.new {|animal| puts " i love #{animal}"}
#here a proc is assigned to a variable
stuff.call("pandas") #then a value is given to that proc
#returning "i love pandas"

#lambda
lproc = lambda { |a,b| puts "#{a + b} <- the sum"}
lproc.call(1,2) #a normal proc would be ok, but
#a lambda block binds it to a proc but with stricter
#argument checking, plus they don't affect the flow of
#the application outside the block



shoes = {1 => 'blue', 2 => 'white'}
shoes[3] = "red" #add new element to hash
p shoes
p shoes.has_key?(1)
p shoes.has_value?("red")
shoes.delete(1)
p shoes
shoes.clear
p shoes.empty?


puts "crown digital 2pm monday"
#raise "raising error"

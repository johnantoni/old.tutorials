# handy stuff
module ListUtil
    def swap!(a,b)
      self[a], self[b] = self[b], self[a]
      self
    end

    # this code found on the net at -
    # http://www.bigbold.com/snippets/posts/show/898
  # Chooses a random array element from the receiver based on the weights
  # provided. If _weights_ is nil, then each element is weighed equally.
  # 
  #   [1,2,3].random          #=> 2
  #   [1,2,3].random          #=> 1
  #   [1,2,3].random          #=> 3
  #
  # If _weights_ is an array, then each element of the receiver gets its
  # weight from the corresponding element of _weights_. Notice that it
  # favors the element with the highest weight.
  #
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 1
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 3
  #
  # If _weights_ is a symbol, the weight array is constructed by calling
  # the appropriate method on each array element in turn. Notice that
  # it favors the longer word when using :length.
  #
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "dog"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "cat"
  def random(weights=nil)
    return random(map {|n| n.send(weights)}) if weights.is_a? Symbol
    
    weights ||= Array.new(length, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total
    
    zip(weights).each do |n,w|
      return n if w >= point
      point -= w
    end
  end
  
    def anyone(cutoff=self.length)
      self[rand(cutoff)]
    end
end

class Array
  include ListUtil
end

class String
  include ListUtil
end

# this code shows that Array.random(:foo) is probably working
if __FILE__ == $0
  ar = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  totals = []
  10.times { |n| totals[n] = 0 }
  10000.times do
    ans = ar.random(:round)
    totals[ans] += 1
  end
  expect = 10000.0 / (0...10).to_a.inject(0) {|sum, n| sum += n}
  printf "weight : times |   t/w : error (%2.2f expected t/w)\n", expect
  printf "------------------------------\n"
  10.times do |n|
    #dif = (n.zero?) ? 0 : totals[n] - totals[n-1]
    share = (n.zero?) ? 0 : totals[n] / n.to_f
    percent = (n.zero?) ? 0 : share / expect
    printf "%6d : %5d | %3.2f : %2.2f\n", n, totals[n], share, percent
  end
end



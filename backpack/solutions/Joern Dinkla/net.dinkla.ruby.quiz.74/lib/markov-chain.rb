require 'pretty-print'

# 
# A Markov Chain contains a graph which edges are labeled with probabilities.
# The graph is stored as two hashes, one for the absolute probabilites, one for
# the relative probabilities. The nodes of the graph correspond to the keys of the hashes.
#
# The rand() method is worst case O(n), for small lists this is ok, but for
# large lists binary search will be better O(lg n)
#

class MarkovChain 

  attr_reader :order
  
  # Initializes the hashes.
  #
  def initialize(order = 1)
    @order = order
    @absolute = {}
    @relative = {}
    @sum_edges = {}
    @dirty = {}
  end
  
  # The nodes of the graph correspond to the keys of the hashes.
  #
  def nodes
    @absolute.keys()
  end
  
  # Add an edge from node a to node b.
  #
  def add(a, b)
    # this dup is needed, otherwise elements will be overwritten
    a = a.dup() if a.instance_of?(Array)
    @absolute[a] ||= {} 
    @absolute[a][b] ||= 0
    @absolute[a][b] += 1
    @sum_edges[a] ||= 0
    @sum_edges[a] += 1
    @dirty[a] = true
  end

  # Adds a list of elements pairwise.
  #
  def add_elems(elems)
    if ( 1 == @order )
      a = nil
      elems.each() do |b|
        add(a, b) if ( a )
        a = b
      end
    else
      a = []
      elems.each() do |b|
        if ( a.length() == @order )
          add(a, b)
          a.shift()
        end
        a.push(b)
      end
    end
  end

  # Calculates all the relative cumulative probabilities.
  #
  def recalc_all()
    @relative = @absolute.dup()
    @relative.each_pair do | a, hash |
      recalc(a) if @dirty[a]
    end
  end
  
  # Calculates the relative cumulative probabilities.
  #
  def recalc(a)
    cum = 0.0
    @relative[a] = @absolute[a].dup()
    sum = @sum_edges[a] * 1.0
    @relative[a].each_pair do | b, value|
      cum = cum + ( value / sum )
      @relative[a][b] = cum
    end
    @dirty.delete(a)
    @relative[a]
  end
  
  # Generates a random successor of node a according to the probabilities learned 
  # from the example texts.
  #
  def rand(a)
    recalc(a) if @dirty[a]
    if a.nil? || @relative[a].nil? || @relative[a].length() == 0
      return nil
    elsif @relative[a].length() == 1
      return @relative[a].keys[0]
    else
      # this is a linear search now with worst case O(n), TODO log(n) binary search
      value = Kernel.rand()
      candidates = @relative[a].select { |b, prob| prob > value }
      return candidates[0][0]
    end
  end

  def to_s()
    result = []
    result << "MarkovChain"
    @absolute.each_pair do | key, hash |
      result << "#{key.pretty_to_s()}: ABS: #{@absolute[key].pretty_to_s()} - REL: #{@relative[key].pretty_to_s()}"
    end
    result.join("\n")
  end

end

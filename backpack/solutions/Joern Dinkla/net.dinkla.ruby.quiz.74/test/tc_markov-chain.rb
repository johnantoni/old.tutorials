#
require 'test/unit'
require 'markov-chain'

# extend the class for testing
class MarkovChain
  attr_reader :absolute, :relative, :sum_edges, :dirty
end

#
class TestMarkovChain < Test::Unit::TestCase

  def setup()
    @mc1 = MarkovChain.new()
    @mc2 = MarkovChain.new()
    @mc2.add(1,2) 
    @mc3 = MarkovChain.new()
    @mc3.add(1,2) 
    @mc3.add(3,4)
    @mc3.recalc(3)
    @mc4 = MarkovChain.new()
    @mc4.add(1,2) 
    @mc4.add(3,4)
    @mc4.add(1,3)
    @mc4.add(1,4)
    @mc4.add(1,3)
    @mc4.recalc_all()
    
    @mc5 = MarkovChain.new(order = 2)
    @mc5.add([1,2], 3)
    @mc5.add([2,3], 5)
    @mc5.add([1,3], 4)

    @mc6 = MarkovChain.new(order = 2)
    @mc6.add([1,2], 3)
    @mc6.add([2,3], 5)
    @mc6.add([1,2], 4)
    @mc6.add([1,3], 4)
    @mc6.recalc([1,2])
    @mc6.recalc([2,3])
    
    @mc7 = MarkovChain.new(order = 2)
    @mc7.add_elems([20,21,20,22,21,22,20,23])
    @mc7.recalc_all()
    
    @mc8 = MarkovChain.new(order = 3)
    @mc8.add_elems([30,31,32,33,30,31,32,34])
    @mc8.recalc_all()

  end
  
  def test_initialize()
    sub_test_sizes(@mc1, 0, 0, 0, 0)
  end

  #
  def test_add_mc2()
    sub_test_sizes(@mc2, 1, 0, 1, 1)
  end

  #
  def test_add_mc3()
    sub_test_sizes(@mc3, 2, 1, 2, 1)
  end

  #
  def test_add_mc4()
    sub_test_sizes(@mc4, 2, 2, 2, 0)
  end

  #
  def test_add_mc5()
    sub_test_sizes(@mc5, 3, 0, 3, 3)
  end

  #
  def test_add_mc6()
    sub_test_sizes(@mc6, 3, 2, 3, 1)
  end

  #
  def test_add_elems_mc7()
    sub_test_sizes(@mc7, 6, 6, 6, 0)
  end

  #
  def test_add_elems_mc8()
    sub_test_sizes(@mc8, 4, 4, 4, 0)
  end
    
  def test_absolute()
    assert_equal({}, @mc1.absolute)
    assert_equal({1=>{2=>1}}, @mc2.absolute)
    assert_equal({1=>{2=>1}, 3=>{4=>1}}, @mc3.absolute)
    assert_equal({1=>{2=>1,3=>2, 4=>1}, 3=>{4=>1}}, @mc4.absolute)
    assert_equal({[1,2]=>{3=>1}, [2,3]=>{5=>1}, [1,3]=>{4=>1}}, @mc5.absolute)
    assert_equal({[1,2]=>{3=>1, 4=>1}, [2,3]=>{5=>1}, [1,3]=>{4=>1}}, @mc6.absolute)
    assert_equal({[22, 21]=>{22=>1}, [22, 20]=>{23=>1}, [20, 21]=>{20=>1}, [21, 22]=>{20=>1}, [20,22]=>{21=>1}, [21,20]=>{22=>1}}, @mc7.absolute)
    assert_equal({[30,31,32]=>{33=>1,34=>1}, [31,32,33]=>{30=>1}, [32,33,30]=>{31=>1}, [33,30,31]=>{32=>1} }, @mc8.absolute)
  end

  def test_relative()
    assert_equal({}, @mc1.relative)
    assert_equal({}, @mc2.relative)
    assert_equal({3=>{4=>1}}, @mc3.relative)
    assert_equal({1=>{2=>0.25,3=>0.75, 4=>1.0}, 3=>{4=>1}}, @mc4.relative)
    assert_equal({}, @mc5.relative)
    assert_equal({[1, 2]=>{3=>0.5, 4=>1.0}, [2, 3]=>{5=>1.0}}, @mc6.relative)
    assert_equal({[22, 21]=>{22=>1}, [22, 20]=>{23=>1}, [20, 21]=>{20=>1}, [21, 22]=>{20=>1}, [20,22]=>{21=>1}, [21,20]=>{22=>1}}, @mc7.relative)
    assert_equal({[30,31,32]=>{33=>0.5,34=>1.0}, [31,32,33]=>{30=>1}, [32,33,30]=>{31=>1}, [33,30,31]=>{32=>1}}, @mc8.relative)
  end
  
  def test_dirty()
    assert_equal({}, @mc1.dirty)
    assert_equal({1=>true}, @mc2.dirty)
    assert_equal({1=>true}, @mc3.dirty)
    assert_equal({}, @mc4.dirty)
    assert_equal({[1, 2]=>true, [2, 3]=>true, [1, 3]=>true}, @mc5.dirty)
    assert_equal({[1, 3]=>true}, @mc6.dirty)
  end
  
  def test_sum_edges()
    assert_equal({}, @mc1.sum_edges)
    assert_equal({1 => 1}, @mc2.sum_edges)
    assert_equal({1 => 1, 3=>1}, @mc3.sum_edges)
    assert_equal({1 => 4, 3=>1}, @mc4.sum_edges)
    assert_equal({[1, 2]=>1, [2, 3]=>1, [1, 3]=>1}, @mc5.sum_edges)
    assert_equal({[1, 2]=>2, [2, 3]=>1, [1, 3]=>1}, @mc6.sum_edges)
  end

  #
  def test_rand()
    # this is probabilistic    
    n = 10
    1.upto(n) { assert_nil(@mc1.rand(nil)) }
    1.upto(n) { assert_nil(@mc1.rand("x")) }
    1.upto(n) { assert_equal(2, @mc2.rand(1)) }
    1.upto(n) { assert_equal(2, @mc3.rand(1)) }
    1.upto(n) { assert_equal(4, @mc3.rand(3)) }
    1.upto(n*n) { assert_not_nil([2,3,4].index(@mc4.rand(1))) }
    1.upto(n) { assert_nil(@mc4.rand(2)) }
    1.upto(n) { assert_equal(4, @mc4.rand(3)) }
    1.upto(n) { assert_nil(@mc2.rand(4)) }

    1.upto(n*n) { assert_not_nil([3,4].index(@mc5.rand([1,2]))) }
    1.upto(n) { assert_equal(5, @mc5.rand([2,3])) }
    1.upto(n) { assert_nil(@mc5.rand([3,1])) }

  end
    
  #
  def sub_test_sizes(mc, a, b, c, d)
    assert_equal(a, mc.absolute.length(), "absolute")
    assert_equal(b, mc.relative.length(), "relative")
    assert_equal(c, mc.sum_edges.length(), "sum_edges")
    assert_equal(d, mc.dirty.length(), "dirty")
  end
  
end


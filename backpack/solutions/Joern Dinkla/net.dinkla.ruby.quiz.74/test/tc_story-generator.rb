#
require 'test/unit'
require 'story-generator'

LOG_WORDS_NUM = 10

#
class TestStoryGenerator < Test::Unit::TestCase

  def setup()
    @sg1 = StoryGenerator.new()
    @sg1.add(["a", "b", "c", "a", "c", ".", "a"])

    @sg2 = StoryGenerator.new(order = 2)
    @sg2.add(["a", "b", "c", "a", "c", ".", "a"])
  end
  
  def test_initialize()
    assert_not_nil(@sg1.mc)
  end

  def test_generate()
    elems = @sg1.generate(100, "a") 
    elems.each do |e|
      assert(["a", "b", "c", "."].index(e))
    end
  end
  
  def test_story()
    text = @sg1.story(100)
    # todo
  end
  
end


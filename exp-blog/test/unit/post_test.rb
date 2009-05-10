require File.dirname(__FILE__) + '/../test_helper'

class PostTest < Test::Unit::TestCase
  fixtures :posts
  
  def setup
    @post = Post.find(1)
    
  end

  # Replace this with your real tests.
  def test_adding_comment
    @post.comments.create :body => "my test comment"
    @post.reload
    assert_equal 2, @post.comments.size
  end
end

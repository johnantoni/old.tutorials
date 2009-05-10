#
require 'test/unit'
require 'words'

class TestWords < Test::Unit::TestCase

  def test_parse()
    words = Words.parse("THE suburb of          Saffron               Park                   ");
    assert_equal(["THE", "suburb", "of", "Saffron", "Park"], words)

    words = Words.parse("THE suburb.It is,but!!");
    assert_equal(["THE", "suburb", ".", "It", "is", ",", "but", "!", "!"], words)

    words = Words.parse("THE suburb.It is,but!!Grab it?");
    assert_equal(["THE", "suburb", ".", "It", "is", ",", "but", "!", "!", "Grab", "it", "?"], words)

    words = Words.parse("--A.-----------b,c;d:eTf--E");
    assert_equal(["-", "A", ".", "-", "b", ",", "c", ";", "d", ":", "eTf", "-", "E"], words)

    words = Words.parse("A\nB\n\n\r\nC");
    assert_equal(["A", "B", "C"], words)

    words = Words.parse("this (and this is)");
    assert_equal(["this", "and", "this", "is"], words)

  end
  
end


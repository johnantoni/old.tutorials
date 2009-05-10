the_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
puts the_alphabet[0..2] 
puts the_alphabet["DEF"] 
puts the_alphabet[1,2] 
str = "This is a string see"
puts str.downcase
puts str.upcase
puts str.swapcase
puts str.capitalize 
puts str.capitalize! #same as above
puts str.squeeze #removes sets of repeated characters
str.chomp
puts str
str.chop
puts str
puts str.gsub("s","c") #find & replace

require 'Date'
mydate = Date.new(1999, 6, 4) # →  1999-06-04 
mydatejd = Date.jd(2451334) # →  1999-06-04 
mydateord = Date.ordinal(1999, 155) #→  1999-06-04 
mydatecom = Date.commercial(1999, 22, 5) #→  1999-06-04 
Date.jd_to_civil(2451334) #→  [1999,6,4] 
Date.jd_to_civil(2451334) #→  [1999,6,4] 
mydatep = Date.parse("1999-06-04")
puts mydatep
#test date
Date.valid_jd?(3829) #→  3829 
Date.valid_civil?(1999, 13, 43) #→  nil 
puts mydate.mon  #→  6 
puts mydate.yday  #→  155 
puts mydate.day  #→  4

rightnow = Time.new  
puts Time.at(934934932)
puts Time.local(2000,"jan",1,20,15,1) 
puts rightnow.utc
puts rightnow.strftime("The %dth of %B in '%y") 

require 'Time'
puts Time.parse("Tue Jun 13 14:15:01 Eastern Standard Time 2005")
puts DateTime.parse("2006-07-03T11:53:02-0400")

require 'digest/md5' 
md5 = Digest::MD5.digest('I have a fine vest!')
puts "md5 string: #{md5}"
require 'digest/sha1' 
sha1 = Digest::SHA1.digest('I have a fine vest!')
puts "sha1 string: #{sha1}"

#require 'crypt/blowfish' 
#blowfish = Crypt::Blowfish.new("A key up to 56 bytes long") 
#plainBlock = "ABCD1234" 
#encryptedBlock = blowfish.encrypt_block(plainBlock)
#decryptedBlock = blowfish.decrypt_block(encryptedBlock) 
#puts "blowfish string: #{encryptedblock}"

require 'test/unit' 
class TestMac < Test::Unit::TestCase 
  def test_tos 
    assert_equal("FF:FF:FF:FF:FF:FF", 
        MacAddr.new("FF:FF:FF:FF:FF:FF").to_s) 
    assert_not_equal("FF:00:FF:00:FF:FF", 
        MacAddr.new("FF:FF:FF:FF:FF:FF").to_s) 
    assert_not_nil(MacAddr.new("FF:AE:F0:06:05:33")) 
    assert_raise RuntimeError do 
      MacAddr.new("AA:FF:AA:FF:AA:FF:AA:FF:AA") 
    end 
  end 
end

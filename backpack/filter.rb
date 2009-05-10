require 'rubygems'
#require 'fastercsv'
require "time"

#filter methods
class String
  def starts_with?(characters)
    self.match(/^#{characters}/) ? true : false
  end

  def is_empty?
    self.strip.length == 0 ? true : false
  end
end

#csv = FasterCSV.foreach("dctemp.csv") do |row|
    # use row here...
#end

#  arr_of_arrs = FasterCSV.read("dctemp.csv")


#csv = open("dctemp.csv") do |io|
   # code to skip io ahead to the start of the CSV here...
#   FCSV.new(io).read
#end 

require 'csv'  
  people = CSV.read("dctemp.csv")
  joe = people.find_all {|person| person =~ /#/}
 
#when writing back to file I want to sort by column 2 ascending (file has 3 columns)
#  CSV.open("c:/fooreturn.txt","w") do |csv|
  #  joe.each do |person|
  #    puts person
  #  end
#  end
  joe.each do |person|
    puts person
  end

#class Price
#  attr_accessor :code, :name, :price
#  
#  def initialize(code, name, price)
#    @code = code
#    @name = name
#    @price = price
#  end
#end

#require 'Imod'


#    (args.index('sr1_discount') != nil) ? @sr1 = true : @sr1 = false

ruby amgp with rabbitmg tutorial
nanite on github


class Integer
  def odd
      self & 1 != 0
   end
  def even
      self & 1 == 0
  end
end


class Checkout
  attr_accessor :rule, :items, :prices, :total
    
  def initialize(pricing_rules)
    @rule = pricing_rules
    @items = []
    
    @prices = Hash.new
    @prices["FR1"] = 3.11
    @prices["SR1"] = 5.00
    @prices["CF1"] = 11.23
    
    @total = 0
  end

  def scan(item)
    @items.push(item)
    
    check_sr1(@items)
  end
  
  def check_sr1(items)
    tmp = items.select {|v| v =~ /SR1/}
    @prices["SR1"] = 4.50 if tmp.count >= 3
  end
  
  def total
    @total = 0
    @items.sort
    @items.each do |item|
      @total += @prices.fetch("#{item}")
    end
#    puts @total
    
    o = 0
    if @rule == "buy-one-get-one-free"
      @items.group_by{|val| val}.each{|val, occurs| 
#        if occurs.size.even
#        puts occurs.size / 2
#          for i in 0..(occurs.size / 2)
            
#            puts '..'
#            @total -= @prices.fetch("#{val}").to_f
#          end
#        end
        if val == "FR1"
          
          @total -= @prices.fetch("#{val}") * (occurs.size / 2)
#        puts "#{val} occurs #{occurs.size} times"
        end
      }
    end

    #puts o
    puts @total
  end

  def print
    @items.each do |item|
      puts item
    end
  end
end

#prices = Price.new


ao = Checkout.new("buy-one-get-one-free")
ao.scan('FR1')
ao.scan('SR1')
ao.scan('FR1')
ao.scan('FR1')
ao.scan('CF1')
price = ao.total

puts ''

bo = Checkout.new("buy-one-get-one-free")
bo.scan('FR1')
bo.scan('FR1')
price = bo.total

puts ''

co = Checkout.new("buy-one-get-one-free")
co.scan('SR1')
co.scan('SR1')
co.scan('FR1')
co.scan('SR1')
price = co.total

#co.print

#puts co.prices.fetch("SR1")

#a.select {|v| v =~ /[aeiou]/}





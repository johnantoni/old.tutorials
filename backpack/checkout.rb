class Checkout
       
  def initialize(*args)
    @rules = args      
    @items = []
    
    @prices = Hash.new
    @prices["FR1"] = 3.11
    @prices["SR1"] = 5.00
    @prices["CF1"] = 11.23    
  end

  def scan(item)
    @items.push(item)
  end
  
  def check_sr1(items, prices)
    discount = 0
    tmp = items.select {|v| v =~ /SR1/}
    if tmp.count >= 3
      item_discount = prices["SR1"] - 4.50 
      discount = item_discount * tmp.count 
    end
    return discount
  end

  def check_fr1(items, prices)
    discount = 0
      items.group_by{|val| val}.each{|val, occurs| 
        discount += prices.fetch("#{val}") * (occurs.size / 2) if val == "FR1"          
      }
    return discount
  end  
  
  def total
    i = 0
    d = 0
    @items.sort
    
    #total up shopping cart
    @items.each do |item|
      i += @prices.fetch("#{item}")
    end
    
    #check for rules and apply discounts
    d += check_sr1(@items, @prices) if @rules.index('strawberry_discount') != nil
    d += check_fr1(@items, @prices) if @rules.index('buy_one_get_one_free') != nil

    puts " discount applied #{d}\n"
    return i-d
  end
end

puts "Tesco Metro! \n\n"

ao = Checkout.new("buy_one_get_one_free", "strawberry_discount")
ao.scan('FR1')
ao.scan('SR1')
ao.scan('FR1')
ao.scan('FR1')
ao.scan('CF1')
price = ao.total
puts "Total : £" + price.to_s + "\n\n"

bo = Checkout.new("buy_one_get_one_free", "strawberry_discount")
bo.scan('FR1')
bo.scan('FR1')
price = bo.total
puts "Total : £" + price.to_s + "\n\n"

co = Checkout.new("buy_one_get_one_free", "strawberry_discount")
co.scan('SR1')
co.scan('SR1')
co.scan('FR1')
co.scan('SR1')
price = co.total
puts "Total : £" + price.to_s + "\n\n"

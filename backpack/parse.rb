require 'csv'
require 'time'

#filter methods
class String
  def starts_with?(characters)
    self.match(/^#{characters}/) ? true : false
  end

  def is_empty?
    self.strip.length == 0 ? true : false
  end
end

#server class
class Server
  attr_accessor :dc, :rack, :high, :low, :peak_time, :temp_var, :peak_unit

  #initialise object
  def initialize(obj)
    t = Time.parse('0:00:00')    
    if obj[0] != 'DC'
      @dc = obj[0]
      @rack = obj[1]
      @high = obj[2].to_i
      @low = obj[3].to_i
      @peak_time = (obj[4].to_s.length > 0 ? Time.parse(obj[4].to_s) : Time.parse("0:00:00") )
      @temp_var = @high - @low
      if @peak_time.to_f > t.to_f
        t = @peak_time
        @peak_unit = 'y'
      end
    end
  end
  
  #print server details
  def show
    t = Time.parse('0:00:00')
    puts "#{dc} #{rack} #{high} #{low} #{peak_time} #{temp_var} #{peak_unit}"
  end

  #find server by rack id
  def self.find_by_rack(rack)
    found = nil
    ObjectSpace.each_object(Server) { |o|  
      found = o if o.rack == rack  
    }  
    found
  end

  #find server with high temp variations
  def self.find_high_temp()
    i = 0
    t = Time.parse('0:00:00')
    found = nil
    ObjectSpace.each_object(Server) { |o|  
      if (o.peak_time.to_f > t.to_f) && (o.temp_var.to_i > i)# &&  # 
        o.show
        i = o.temp_var # keep counter
        t = o.peak_time
        found = o # record object
      end
    }  
    found # return object with high temp
  end

  #show all server objects
  def self.show_all()
    ObjectSpace.each_object(Server) { |o|  
      o.show
    }  
  end

  #find servers with temps above 70
  def self.show_seventies()
    puts "\nServers with temps above 70:"
    ObjectSpace.each_object(Server) { |o|
      puts "#{o.dc} #{o.rack}" if o.high.to_i >= 70
    }  
  end

end

begin
  #load csv file, ignore whitespace + commented lines, create objects for each server
  csv = File.open("dctemp.csv").each { |line|
    if (!line.starts_with? '#') && !line.is_empty?
    #    Server.new(CSV.parse_line(line))
    #end
  }

  #get server with highest temp variation
#  puts Server.show_all()
#  sh = Server.find_high_temp()
#  puts "Server with high temp:\n#{sh.dc} #{sh.rack}"

  #show servers with temps above 70
#  Server.show_seventies()  
#  p = Time.new
#  p.parse("0:00:00")
#  puts Time.parse("16:30")
end


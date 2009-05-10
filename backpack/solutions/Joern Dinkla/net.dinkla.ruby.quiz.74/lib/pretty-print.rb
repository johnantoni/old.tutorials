#


class NilClass
  def pretty_to_s()
    "nil"
  end
end

class Fixnum
  def pretty_to_s()
    to_s()
  end
end

class Float
  def pretty_to_s()
    to_s()
  end
end

class String
  def pretty_to_s()
    to_s()
  end
end



class Array

  def pretty_to_s()
    results = ["["]
    self.each() do |e|
      results += [ e.pretty_to_s(), "," ] 
    end
    results.pop() if results.length() > 1
    results += [ "]" ]
    results.join("")
  end
  
end

class Hash

  def pretty_to_s()
    results = ["{"]
    self.each() do |e|
      results += [ e.pretty_to_s(), "," ] 
    end
    results.pop() if results.length() > 1
    results += [ "}" ]
    results.join("")
  end
  
end

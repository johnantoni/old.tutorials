homicide = Thread.new do 
      while (1 == 1): 
      puts "Don't kill me!" 
Thread.pass 
      end 
    end 
suicide = Thread.new do 
    puts "This is all meaningless!" 
    Thread.exit 
   end 
Thread.kill(homicide)

first = Thread.new() do 
  myindex = 0 
  while(myindex < 10): 
    puts "Thread One!" 
    sleep 3 #continue runnning 
    myindex += 1 
  end 
end
second = Thread.new() do 
  myindex2 = 0 
  while(myindex2 < 5): 
    puts "Thread Two!" 
    sleep 5 #continue runnning
    myindex2 += 1 
  end 
end    
third = Thread.new() do 
  myindex3 = 0 
  while(myindex3 < 2): 
    puts "Thread Three!" 
    sleep 10 #continue runnning
    myindex3 += 1 
  end 
end
  
first.join() 
second.join() 
third.join() 

t1 = Thread.new { print "w"; Thread.pass; print "a" } 
t2 = Thread.new { print "e"; Thread.pass; print "l" } 
t1.join 
t2.join 

mate = Thread.new do 
  puts "Ahoy! Can I be dropping the anchor sir?" 
  Thread.stop 
  puts "Aye sir, dropping anchor!" 
end 
Thread.pass 
puts "CAPTAIN: Aye, laddy!" 
mate.run 
mate.join 

## fibonacci.rb
require 'benchmark'
              
fibonacci1 = Hash.new {|hsh,key| hsh[key] = key < 2 ? key : hsh[key-1] + hsh[key-2] }
fibonacci2 = Hash.new {|hsh,key| hsh[key] = key < 2 ? key : hsh[key-1] + hsh[key-2] }

n = ARGV[0].to_i + 1

Benchmark.bmbm do |x|
  x.report("With IO:")    { n.times {|i| STDERR.puts "#{i} => #{fibonacci1[i]}"} }
  x.report("Without IO:") { n.times {|i| fibonacci2[i] } }
end

## fibonacci_raw.rb
fibonacci1 = Hash.new {|hsh,key| hsh[key] = key < 2 ? key : hsh[key-1] + hsh[key-2] }

n = ARGV[0].to_i + 1

n.times {|i| STDERR.puts "#{i} => #{fibonacci1[i]}"}

## output [text]

$ ruby -v
ruby 1.8.6 (2007-03-13 patchlevel 0) [i686-darwin8.10.3]

$ ruby fibonaci.rb 36 2> /dev/null
Rehearsal -----------------------------------------------
With IO:      0.000000   0.000000   0.000000 (  0.000561)
Without IO:   0.000000   0.000000   0.000000 (  0.000110)
-------------------------------------- total: 0.000000sec

                  user     system      total        real
With IO:      0.000000   0.000000   0.000000 (  0.000369)
Without IO:   0.000000   0.000000   0.000000 (  0.000024)

$ time ruby fibonacci_raw.rb 36 2> /dev/null

real    0m0.006s
user    0m0.003s
sys     0m0.003s

# Agora com 10.000

$ ruby fibonacci.rb 10_000 2> /dev/null
Rehearsal -----------------------------------------------
With IO:      7.790000   0.060000   7.850000 (  7.923604)
Without IO:   0.040000   0.010000   0.050000 (  0.041653)
-------------------------------------- total: 7.900000sec

                  user     system      total        real
With IO:      7.750000   0.040000   7.790000 (  7.871052)
Without IO:   0.000000   0.000000   0.000000 (  0.004245)

$ time ruby fibonacci_raw.rb 10_000 2> /dev/null

real    0m7.862s
user    0m7.795s
sys     0m0.059s
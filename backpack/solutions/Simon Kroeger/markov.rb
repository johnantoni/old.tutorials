before, line, order = ['.'], '', ARGV.shift.to_i

txt = ARGF.read.tr('"/*\\()[]', ' ').downcase
txt = txt.gsub(/[^'\w]/, ' \0 ').gsub(/\s+/, ' ')

500.times do
  ary = txt.scan(/ #{before.join(' ')} (\S+)/).transpose.first
  before << ary[rand(ary.size)]
  before.shift if before.length > order
  (puts line; line = '') if line.length > 50 &&  /\w/ =~ before.last
  line << ( /\w/ =~ before.last && !line.empty? ? ' ' : '') << before.last
end

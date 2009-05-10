require 'optparse'

module TransitionMatrix
    def TransitionMatrix.create_transition_matrix(buff, order)
	buff.gsub!(/\n/, ' ')
	transition = Hash.new
	(buff.size-order-1).times { |i|
	    subchain = buff[i, order]
	    transition[subchain] = Array.new unless transition[subchain]
	    transition[subchain] << buff[i+1,order]
	}
	return transition
    end
end

class TextGenerator
    def initialize(matrix, order)
	@matrix = matrix
        @order = order
    end

    def generate_text(length)
	keys = @matrix.keys
	result=keys[rand(keys.size)]
	(length-@order-1).times { |i|
	    subchain = result[i, @order]
	    candidates = @matrix[subchain]
	    char = candidates[rand(candidates.size)]
	    result += char[char.size-1].chr
	}
	return result
    end
end

path = ""
size = 0
order = 1

parser = OptionParser.new { |opts|
    opts.banner = "Use: quiz74.rb -t text_file -l size [-o order]"

    opts.separator ""
    opts.on("-t", "--text FILE", "Text to analyze") { |p|
	path = p
    }
    opts.on("-l", "--length N", Integer, "Length of generated text (characters)") { |s|
	size = s
    }
    opts.on("-o", "--order N", Integer, "Order of Markov chain (default 1)") { |o|
	order = o
    }
    opts.separator ""
    opts.on_tail("-h", "--help", "Shows this message and exits") {
	puts opts
	exit
    }
}
parser.parse!(ARGV)

if path!="" and size > 0
    text = IO.read(path)
    matrix = TransitionMatrix.create_transition_matrix(text, order)
    generator = TextGenerator.new(matrix, order)
    puts generator.generate_text(size)
else
    puts parser
end


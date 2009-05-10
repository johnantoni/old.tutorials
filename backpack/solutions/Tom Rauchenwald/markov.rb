class Markov
    def initialize(filename)
        @frequencies=Hash.new
        @text=Array.new
        unless File.exists?(filename)
            print("File not found!\n")
            exit
        end
        File.open(filename) do |io|
            io.each do |line|
                line.each(' ') do |word|
                    word.strip!; word.gsub!('"','')
                    next if word.empty?
                    @text<< word
                end
            end
        end
        # The structure of the frequencies-hash that
        # I build here is as follows
        # [word1,word2] => {followingword1 => frequency, followingword2 => frequency...}
        2.upto(@text.length-1) do |i|
            tupel=@text[i-2..i-1]
            word=@text[i]
            unless @frequencies.has_key?(tupel)
                @frequencies[tupel]={word => 1}
                next
            end
            if @frequencies[tupel].include?(word)
                @frequencies[tupel][word]+=1
            else
                @frequencies[tupel][word]=1
            end
        end
    end

    def print_sentences n
        n.times {print_sentence}
        print "\n"
    end

    def print_sentence
        start=Array.new
        i=rand(@text.length)
        #find the beginning of a sentence
        loop do
            if @text[i]=~/^[A-Z]/ &&
                    !(@text[i]=~/[.!?]/) &&
                    !(@text[i+1]=~/[.!?]/)
                start=@text[i],@text[i+1]
                i+=1
                break
            end
            i+=1
            i==0 if i==@text.length
        end
        buffer=start
        print start.join(" "), " "
        #build new sentence
        60.times do
            words=@frequencies[buffer]
            space=Array.new
            words.each_pair do |word, frequency|
                frequency.times {space << word}
            end
            word = space[rand(space.length)]
            buffer.shift
            buffer << word
            print word.gsub(/[\"\']/,''), " "
            break if word=~/[.!?]$/
        end
    end
end

unless ARGV.length==2
    print "Usage: markov.rb <textfile> <number of sentences to print>" 
end
m=Markov.new(ARGV[0])
m.print_sentences(ARGV[1].to_i)

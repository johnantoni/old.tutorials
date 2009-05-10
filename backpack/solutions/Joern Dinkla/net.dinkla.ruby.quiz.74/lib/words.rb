# A parser for texts in native languages, for example english or german.
# 
# Example:
#   "To be    or not to    be."
#
# will be parsed into the array
#
# ["To", "be", "or", "not", "to", "be", "."]
#
class Words

  attr_reader :words
  
  # Returns the words of a file.
  #
  def Words.parse_file(filename)
    i = 1
    all_words = []
    File.foreach(filename) do |line|
      ws = Words.parse(line)
      next if ws.nil?
      all_words += ws
      i += 1 
      if ( i % LOG_FILE_READ_NUM == 0 && $VERBOSE ) 
        puts "  Read #{i} lines." 
        STDOUT.flush()
      end
    end
    all_words
  end

  # Returns the words of a line.
  #
  def Words.parse(line)
    # replace newline
    line.gsub!(/\r\n/, '')
    return nil if line.length == 0
    # seperate all special characters by blanks
    line.gsub!(/([,;!?:.])/, ' \1 ')
    # remove unused special characters
    line.gsub!(/[+=\t\r\n()"]/, " ")
    line.gsub!(/\-+/, " - ")
    line.gsub!(/'[^t]/, "")
    # split the line into words
    words = line.split(/[ ]+/).select { |w| w.length > 0 }
    words
  end

end

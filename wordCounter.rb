
@words = []
@match = false
@wordCount = 0

def extract()
  tokens = [] # represents the words in a line
  # handle exception if file not found
  begin
    file = File.open(ARGV[0], 'r')
    if file
      puts "File opened successfully"
    end
  rescue Errno::ENOENT
    warn "File not found"
    exit 1
  end
  file.each do |line|
    puts "Parsing: " + line
    # if line is empty, continue
    if line.chomp == ""
      next
    end
    tokens = line.split(' ')
    tokens.each {|x|
      @wordCount += 1
      @words.each do |w|
        # strip x of punctuation and downcase it
        if x.gsub(/[.!?]/, '').downcase == w.value
          @match = true
          w.increment()
          puts "Raising counter for #{w.value}"
        end
      end
      # if x didn't match any existing word, make a new word with x as the value
      if @match == false
        @words << Word.new(x.gsub(/[.,!?]/, '').downcase)
        puts "Made new word: #{@words[-1].value}"
      end
      @match = false
    }
  end
  file.close
  puts "Word count: #{@wordCount}"
  puts "Distinct word count: #{@words.length}"
end

# represents a word
class Word
  @value = "" # represents the actual word
  @counter = 0 # represents all occurrences of this word
  @@total = 0 # static variable representing the number of unique words

  # constructor
  def initialize(word)
    @value = word
    @counter = 1
    @@total += 1
  end

  # getter
  def value
    @value
  end

  def increment()
      @counter += 1
  end

  # getter
  def counter
      @counter
  end

end

def print()
    @words.each {|x| puts x.value}
end

def to_csv
  require 'csv'
  CSV.open("words.csv", "wb") do |csv|
    puts "\"Words\",\"Count\""
    @words.each do |w|
      array = [w.value, w.counter.to_s]
      csv << array
    end
  end
end

def validate_args
  if ARGV.length != 1
    warn "usage: prog textfile"
    exit 1
  end
  if !(ARGV[0].include? ".txt")
    warn "usage: prog textfile"
    exit 1
  end
end

def main()
  validate_args()
  extract()
  #print()
  to_csv()
end

main()

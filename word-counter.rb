def print_hash (hash)
  hash.map { |k,v| puts "#{k}: #{v}"}
end

# Makes a hash where the keys are words in the file and the values are the
# number of instances of that word. If a word is not in the hash as a key, it
# makes a new key value pair. Lastly, prints the hash and closes the file.
def process_file (file)
  word_count = 0
  words = Hash.new
  file.each do |line|
    puts "Parsing: " + line
    # if line is empty, continue
    if line.chomp == ""
      next
    end
    tokens = line.split(' ') # make tokens based on space delimiter
    tokens.each { |x|
      word_count += 1
      x = x.downcase.gsub(/[.,!?]/, '') # strip punctuation from x
      # if words has x as a key, increment the value, otherwise make a new
      # key value pair
      if words.has_key?(x)
        words[x] = words[x] + 1
      else
        words[x] = 1
      end
    }
  end
  file.close
  puts "File closed"
  print_hash(words)
  puts "Word count: #{word_count}"
end

# Validates the command line arguments. Checks for only one arg and that it is
# a text file.
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

# Attempts to open the file specified in the command line argument, then
# calls a helper function to process the file.
def start
  begin
    file = File.open(ARGV[0], 'r')
    if file
      puts "File opened successfully"
    end
  rescue Errno::ENOENT
    warn "File not found"
    exit 1
  else
    process_file(file)
  end
end

def main
  validate_args()
  start()
end

main()

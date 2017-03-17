require 'benchmark'

class DictionaryMapper

  ELEMENT_PATTERN = [
   [3,3,4],
   [3,4,3],
   [4,3,3],
   [5,5],
   [4,6],
   [6,4],
   [7,3],
   [3,7],
   [10]
  ]

  COMBINATION_LETTERS = 
  {
    "2" => ["A", "B", "C"],
    "3" => ["D", "E", "F"],
    "4" => ["G", "H", "I"],
    "5" => ["J", "K", "L"],
    "6" => ["M", "N", "O"],
    "7" => ["P", "Q", "R", "S"],
    "8" => ["T", "U", "V"],
    "9" => ["W", "X", "Y", "Z"]
  }

  def map_number_to_string(digits)
  
    input = File.open('input.txt', 'r').read
    unless /^\d{10}$/ === digits
      puts "Please enter correct numbers."
      exit 0
    end

    puts "parsing number #{digits}"
    if digits =~ /[0-1]/
      puts 'invalid number'
      exit 0
    end

    digits_to_chars = digits.chars

    expression = {}
    words = {}
    ELEMENT_PATTERN.each do |pattern|
      position = 0
      pattern.each do |element|
        expression["#{position}_#{position+element-1}"] = "^" + digits_to_chars[position..(position+element-1)].map { |c| "(#{COMBINATION_LETTERS[c].join('|')})" }.join + "$"
        position += element
      end
    end

    puts 'Scanning...'
    expression.each_pair do |key, exp|
      words[key] = input.scan(Regexp.new(exp)).map(&:join)
    end

    puts 'Computing..........'
    ELEMENT_PATTERN.each do |pattern|
      position = 0
      is_blank = true
      pattern.each do |element|
        break if (is_blank = words["#{position}_#{position+element-1}"].empty?)
        position += element
      end
      if !is_blank
        combinations(pattern, words)
      end
    end
  end

  def combinations element_pattern, words
    position = 0
    collection = []
    element_pattern.each do |element|
      collection << words["#{position}_#{position+element-1}"]
      position += element
    end
    if collection.count >1
      products = collection[0].product(*collection[1..-1])
    else
      products = collection[0]
    end
    puts products.to_s
  end
end
#accepting input from user
puts "Enter 10 digit number"
digits = gets.chomp

if digits.length > 0
  input_digits = digits
else
  input_digits = "2282668687"
end

p Benchmark.measure {
  DictionaryMapper.new.map_number_to_string input_digits
}
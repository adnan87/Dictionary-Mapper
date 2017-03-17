require 'benchmark'

p Benchmark.measure {
  input = File.open('input.txt', 'r').read

  letters = {
    "2" => ["A", "B", "C"],
    "3" => ["D", "E", "F"],
    "4" => ["G", "H", "I"],
    "5" => ["J", "K", "L"],
    "6" => ["M", "N", "O"],
    "7" => ["P", "Q", "R", "S"],
    "8" => ["T", "U", "V"],
    "9" => ["W", "X", "Y", "Z"]
  }
  #accepting input from user
  puts "Enter 10 digit number"

  digits = gets.chomp
  # digits = '2282668687'
  unless /^\d{10}$/ === digits
    puts "Please enter correct numbers."
    exit 0
  end

  if digits =~ /[0-1]/
    puts 'invalid number'
    exit 0
  end

  digits = digits.chars
  element_pattern = [
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

  # Total number of combinations
  combs = "^" + digits.map { |c| "(#{letters[c].join('|')})" }.join + "$"

  hash = {}
  values = {}
  element_pattern.each do |pattern|
    position = 0
    pattern.each do |element|
      hash["#{position}_#{position+element-1}"] = "^" + digits[position..(position+element-1)].map { |c| "(#{letters[c].join('|')})" }.join + "$"
      position += element
    end
  end

  hash.each_pair do |key, exp|
    values[key] = input.scan(Regexp.new(exp)).map(&:join)
  end

  def combinations element_pattern, values
    position = 0
    collection = []
    element_pattern.each do |element|
      collection << values["#{position}_#{position+element-1}"]
      position += element
    end
    if collection.count >1
      products = collection[0].product(*collection[1..-1])
    else
      products = collection[0]
    end
    puts products.to_s
  end

  element_pattern.each do |pattern|
    position = 0
    is_blank = true
    pattern.each do |element|
      break if (is_blank = values["#{position}_#{position+element-1}"].empty?)
      position += element
    end
    if !is_blank
      combinations(pattern, values)
    end
  end
}

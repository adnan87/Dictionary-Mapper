  input = File.open('input1.txt', 'r').read

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

  puts "parsing number #{digits}"
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

  combs = "^" + digits.map { |c| "(#{letters[c].join('|')})" }.join + "$"

  hash = {}
  values = {}
  element_pattern.each do |pattern|
    j = 0
    pattern.each do |i|
      hash["#{j}_#{j+i-1}"] = "^" + digits[j..(j+i-1)].map { |c| "(#{letters[c].join('|')})" }.join + "$"
      j += i
    end
  end

  hash.each_pair do |key, exp|
    values[key] = input.scan(Regexp.new(exp)).map(&:join)
  end

  def combinations element_pattern, values
    j = 0
    ye = []
    element_pattern.each do |i|
      ye << values["#{j}_#{j+i-1}"]
      j += i
    end
    if ye.count >1
      products = ye[0].product(*ye[1..-1])
    else
      products = ye[0]
    end
    puts products.to_s
  end
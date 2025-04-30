# Homework 1
# Luca Heringer Megiorin
# 231003390


# Exercise 1
def exercise1
  
  puts "1) Exercise 1\n a) item A:"   # Exercise 1, item A
  test1 = palindrome?("A man, a plan, a canal -- Panama")     # true
  test2 = palindrome?("Madam, I'm Adam!")                     # true
  test3 = palindrome?("Abracadabra")                          # false
  puts %(   > palindrome?("A man, a plan, a canal -- Panama")  =>  )  + test1.to_s  
  puts %(   > palindrome?("Madam, I'm Adam!")                  =>  )  + test2.to_s                  
  puts %(   > palindrome?("Abracadabra")                       =>  )  + test3.to_s                      

  puts " b) item B:"   # Exercise 1, item B
  test1 = count_words("A man, a plan, a canal -- Panama")   # => {'a' => 3, 'man' => 1, 'canal' => 1, 'panama' => 1, 'plan' => 1}
  test2 = count_words "Doo bee doo bee doo"                 # => {'doo' => 3, 'bee' => 2}
  puts %(   > count_words("A man, a plan, a canal -- Panama")  =>  )  + test1.to_s          
  puts %(   > count_words "Doo bee doo bee doo"                =>  )  + test2.to_s             
end

# Exercise 1, item A
def palindrome?(string)
    string = string.gsub(/\W/i,"").downcase
    string == string.reverse
end
  

# Exercise 1, item B
def count_words(string)
    hs = Hash.new(0)
    string.scan(/\b\w+\b/i).each do |word|
      hs[word.downcase] += 1
    end
    hs
end

# Exercise 2
def exercise2
  
  puts "2) Exercise 2\n a) item A:"   # Exercise 2, item A
  test1 = rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "S" ] ])     # => returns the list ["Pam", "S"] wins since S>P
  test2 = rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "P" ] ])     # => returns the list [ "Kristen", "P" ] wins it's a draw
  test3 = rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "R" ] ])     # => returns the list [ "Kristen", "P" ] wins since P>R    
  puts %(   > rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "S" ] ])  =>  )  + test1.to_s  
  puts %(   > rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "P" ] ])  =>  )  + test2.to_s                  
  puts %(   > rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "R" ] ])  =>  )  + test3.to_s                      

  puts " b) item B:"   # Exercise 2, item B
  tournament = [
  [
    [ ["Kristen", "P"], ["Dave", "S"] ],
    [ ["Richard", "R"], ["Michael", "S"] ],
  ],
  [
    [ ["Allen", "S"], ["Omer", "P"] ],
    [ ["David E.", "R"], ["Richard X.", "P"] ]
  ]
  ]

  test1 = rps_tournament_winner_a(tournament)
  test2 = rps_tournament_winner_b(tournament)
  puts %(   > rps_tournament_winner_a(tournament)  =>  )  + test1.to_s          
  puts %(   > rps_tournament_winner_b(tournament)  =>  )  + test2.to_s             
end

# Exercise 2, item A
class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

def rps_game_winner(game)
raise WrongNumberOfPlayersError unless game.length == 2
  player1,strat1 = game[0]
  player2,strat2 = game[1]
  unless (strat1 =~ /(R|S|P)$/i and strat2 =~ /(R|S|P)$/i)
    raise NoSuchStrategyError
  end

  if strat1 == strat2 ||                          # Draw, Player 1 wins
     (strat1 == 'R' && strat2 == 'S') ||          # Rock beats Scisors
     (strat1 == 'S' && strat2 == 'P') ||          # Scisors beats Paper
     (strat1 == 'P' && strat2 == 'R')             # Paper beats Rock
    return [player1, strat1]
  else
    return [player2, strat2]
  end
end

# Exercise 2, item B (option1)
def rps_tournament_winner_a(matches)
  
  # If match is 
  if matches[0][0].is_a?(String)
    return rps_game_winner(matches)
  end

  # Prepping recursion
  leftWinner = rps_tournament_winner_a(matches[0])
  rightWinner = rps_tournament_winner_a(matches[1])

  # Play a match between the two winners
  rps_game_winner([leftWinner, rightWinner])
end

# Exercise 2, item B (option2)   -> Uses ruby's features to the fullest
def rps_tournament_winner_b(matches) 
  return rps_game_winner matches if matches.first.first.is_a? String      # Base case
  rps_game_winner matches.map {|match| rps_tournament_winner_b(match)}    # Recursive
end


# Exercise 3
def exercise3
  
  puts "3) Exercise 3:"   # Exercise 3
  test1 = combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams','scream'])              # [["cars", "racs", "scar"], ["four"], ["for"], ["potatoes"], ["creams", "scream"]]
  
  puts %(   > combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams','scream'])  =>  )  + test1.to_s                           
end


# HINT: you can quickly tell if two words are anagrams by sorting their
# letters, keeping in mind that upper vs lowercase doesn't matter
def combine_anagrams(words)
  words.group_by {|word| word.chars.sort.join}.values
end

# Exercise 4
def exercise4
  
  puts "4) Exercise 4\n a) item A:"   # Exercise 1, item A
  dessert1 = Dessert.new("Cheesecake", 350)
  dessert2 = Dessert.new("Fruit Salad", 120)

  puts "   > Dessert 1 healthy? #{dessert1.healthy?}"     # false
  puts "   > Dessert 2 healthy? #{dessert2.healthy?}"     # true     
  puts "   > Dessert 1 tasty? #{dessert1.delicious?}"     # true
  puts "   > Dessert 2 tasty? #{dessert2.delicious?}"     # true                     

  puts " b) item B:"   # Exercise 1, item B
  jelly1 = JellyBean.new("Gummy Bear", 180, "strawberry")
  jelly2 = JellyBean.new("Mysterious Blob", 220, "black licorice")

  puts "   > Jelly 1 healthy? #{jelly1.healthy?}"         # true
  puts "   > Jelly 2 healthy? #{jelly2.healthy?}"         # false
  puts "   > Jelly 1 delicious? #{jelly1.delicious?}"     # true
  puts "   > Jelly 2 delicious? #{jelly2.delicious?}"     # false
  
end


# Exercise 4, item A
class Dessert
  attr_accessor :name, :calories

  def initialize(name, calories)
    @name = name
    @calories = calories
  end

  def healthy?
    calories < 200
  end

  def delicious?
    true
  end
end

# Exercise 4, item B
class JellyBean < Dessert
  attr_accessor :flavor

  def initialize(name, calories, flavor)
    super(name, calories)  # Lets Dessert handle name & calories
    @flavor = flavor
  end

  def delicious?
    flavor == "black licorice" ? false : true
  end
end

# Exercise 5
def exercise5
  
  puts "5) Exercise 5:"   # Exercise 1, item A
  f = Foo.new
  f.bar = 1
  f.bar = 2

  puts "   > f.bar_history  =>  #{f.bar_history}"     # [nil,1,2]        
  
end

# Exercise 5
class Class
  def attr_accessor_with_history(attr_name)
  attr_name = attr_name.to_s # make sure it's a string
  attr_reader attr_name # create the attribute's getter
  attr_reader attr_name+"_history" # create bar_history getter
  class_eval %Q(
    def #{attr_name}=(value)
      if @#{attr_name}_history == nil
        @#{attr_name}_history = [nil]
      end
      @#{attr_name}_history << value
      @#{attr_name} = value
    end
  )
  end
end

class Foo
  attr_accessor_with_history :bar
end

# Exercise 6
def exercise6
  
  puts "5) Exercise 5\n a) Item A:"   # Exercise 6, item A

  puts "   > 1.dollar.in(:rupees)  =>  #{1.dollar.in(:rupees)}"    
  puts "   > 10.rupees.in(:euro)   =>  #{10.rupees.in(:euro)}"    
  
  
  puts " b) Item B:"   # Exercise 6, item B
  test1 = "A man, a plan, a canal -- Panama".palindrome?     # true
  test2 = "Madam, I'm Adam!".palindrome?                     # true
  test3 = "Abracadabra".palindrome?                          # false
  puts %(   > "A man, a plan, a canal -- Panama".palindrome?  =>  #{test1})  
  puts %(   > "Madam, I'm Adam!".palindrome?                  =>  #{test2})                  
  puts %(   > "Abracadabra".palindrome?                       =>  #{test3}) 

  puts " c) Item C:"   # Exercise 6, item C
  test1 = [1,2,3,2,1].palindrome? # => true
  test2 = [1,2,3,4,5].palindrome? # => false
  puts %(   > [1,2,3,2,1].palindrome?  =>  #{test1}) 
  puts %(   > [1,2,3,4,5].palindrome?  =>  #{test2}) 

end

# Exercise 6 A
class Numeric
  @@currencies = {'dollar' => 1, 'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}
  
  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      puts method_id
      super
    end
  end

  def in(currency)
    singular_currency = currency.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self / @@currencies[singular_currency]
    end
  end
end

# Exercise 6 B
class String
  def palindrome?()
    string = self.gsub(/\W/i,"").downcase.reverse
    string == string.reverse
  end
end

# Exercise 6 C
module Enumerable
  def palindrome?()
    self == self.reverse
  end
end




puts %(HOMEWORK 1 - LUCA MEGIORIN)
exercise1
puts %(\n)
exercise2
puts %(\n)
exercise3
puts %(\n)
exercise4
puts %(\n)
exercise5
puts %(\n)
exercise6
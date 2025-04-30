# EngenhariaSoftware-Homework1
###Como LLMs pode promover o aprendizado e o desenvolvimento de aplicações Ruby?

Ruby é uma linguagem orientada a objetos de alto nível e, portanto, de fácil entendimento para programar. Todavia, a verdadeira complexidade está na aprendizagem das expressões idiomáticas de Ruby, como o modo poético, a orientação a objetos profunda (tudo é um objeto e todo comando é um método), dentre outros fatores que tornam a programação em Ruby um desafio para aqueles que nunca tiveram contato com ela antes. Para isso, foram propostos 6 exercícios [(presentes nesse arquivo)](HW1RubyCalisthenics.pdf) a fim de praticar os conceitos de Ruby.

## Questão 1
### Item A
A primeira parte da questão visava a formulação de um método que determinasse se uma frase é um palíndromo ou não. Por exemplo:
```ruby
palindrome?("A man, a plan, a canal -- Panama") #=> true
palindrome?("Madam, I'm Adam!") # => true
palindrome?("Abracadabra") # => false 
```
Para isso, com auxilio do site [rubular.com](https://rubular.com/) para estudar regular expressions, foi desenvolvido o seguinte código:
```ruby
def palindrome?(string)
    string = string.gsub(/\W/,"").downcase
    string == string.reverse
end
```
O código transforma a string recebida em uma string com apenas palavras e letras minúsculas (o método ```gsub(/\W/,"")``` substitui as ocorrências de non-words por uma string vazia, ou seja, unifica todas as palavras). Após isso, é feita uma comparação entre a string e a sua versão inversa (```reverse```) e, se for verdadeira, é um palíndromo.

### Item B
Para o segundo item, dever-se-ia criar um método que retornasse um hash com palavras da string como chaves e a quantidade de vezes em que elas apareciam. O resultado obtido seria como o abaixo:
```ruby
count_words("A man, a plan, a canal -- Panama")
# => {'a' => 3, 'man' => 1, 'canal' => 1, 'panama' => 1, 'plan' => 1}
count_words "Doo bee doo bee doo" # => {'doo' => 3, 'bee' => 2}
```
A função criada inicia gerando um hash vazio e, para cada valor obtido no ```scan(/\b\w+\b/i)``` (que separa todas as palavras de uma forma iterável pelo ```each```), adiciona 1 ao seu valor no hash, retornando-o ao final do loop.  

```ruby
def count_words(string)
    hs = Hash.new(0)
    string.scan(/\b\w+\b/i).each do |word|
      hs[word.downcase] += 1
    end
    hs
end
```

## Questão 2
### Item A
Nesse item, era necessário criar um método para uma partida de pedra papel tesoura, que recebesse uma lista com dois jogadores e suas ações, e retornasse o vencedor, como no exemplo abaixo:
```ruby
[ [ "Kristen", "P" ], [ "Pam", "S" ] ] # => Retorna a lista ["Pam", "S"], pois  S>P
```

A estrutura básica para responder à questão foi fornecida (o tratamento de erros para um jogo de tamanho diferente de 2 jogadores), e foi criada um método que separava o nome dos jogadores e suas estratégias, checava se eram estratégias válidas (usando regex para checar se era R, S ou P, ou suas variantes minúsculas) e comparava os resultados para retornar a lista do jogador e estratégia vencedores.

```ruby
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
```
### Item B
Extendendo do item anterior, o objetivo dessa questão era fazer um torneio de pedra papel tesoura (com 2<sup>n</sup> jogadores), como o torneio abaixo: 
```ruby
[
[
[ ["Kristen", "P"], ["Dave", "S"] ],          # ["Dave", "S"] ganha
[ ["Richard", "R"], ["Michael", "S"] ],       # ["Richard", "R"] ganha
],   # Entre os vencedores há a partida [["Dave", "S"], ["Richard", "R"]], e ["Richard", "R"] ganha
[
[ ["Allen", "S"], ["Omer", "P"] ],            # ["Allen", "S"] ganha
[ ["David E.", "R"], ["Richard X.", "P"] ]    # ["Richard X.", "P"] ganha
] # Entre os vencedores há a partida [["Allen", "S"], ["Richard X.", "P"]], e ["Allen", "S"] ganha
]
# A última partida do torneio, entre ["Allen", "S"] e ["Richard", "R"] tem como vencedor ["Richard", "R"]
```
Para isso, foi criada um método recursivo que, primeiramente, checava se estava em uma partida ou se ainda deveria adentrar mais no array do torneio (verificando se o primeiro item do primeiro array era uma string, dado que, se for, não haverá uma recursão após essa partida).
```ruby
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
```




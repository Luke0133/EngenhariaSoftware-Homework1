# EngenhariaSoftware-Homework1
### Como LLMs pode promover o aprendizado e o desenvolvimento de aplicações Ruby?

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
A função criada inicia gerando um hash vazio e, para cada valor obtido no ```scan(/\b\w+\b/i)``` (que separa todas as palavras de uma forma iterável pelo ```each```), adiciona 1 ao seu valor no hash, retornando-o ao final do loop. No início, o código continha apenas o ```\w```, o que tornava o match incorreto. O uso de um LLM para realizar o debug permitiu a correção do erro com um regex melhorado, o que poupou o tempo de procurar pela internet um bug muito específico para essa questão.   

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
Estudando com o LLM, ao perguntar sobre uma solução mais funcional e concisa, foi fornecido o código a seguir, que elimina o uso de `if else` e relaciona ideias de forma mais direta, o que facilitaria o entendimento de um leitor.
```ruby
def rps_game_winner(game)
  raise WrongNumberOfPlayersError unless game.length == 2

  player1, strat1 = game[0]
  player2, strat2 = game[1]

  valid = %w[R P S]
  raise NoSuchStrategyError unless valid.include?(strat1.upcase) && valid.include?(strat2.upcase)

  # Normalize strategies to uppercase
  strat1,strat2 = strat1.upcase, strat2.upcase

  beats = { 'R' => 'S', 'S' => 'P', 'P' => 'R' }

  # Return the winning player — one-line expression, no if/else
  [player1, strat1] if strat1 == strat2 || beats[strat1] == strat2 or [player2, strat2]
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
Para isso, foi criada um método recursivo que, primeiramente, checava se estava em uma partida ou se ainda deveria adentrar mais no array do torneio (verificando se o primeiro item do primeiro array era uma string, dado que, se for, não haverá uma recursão após essa partida). Após isso, ele gera o vencedor dos jogos da lista da esquerda e da lista da direiita (dado que a lista de torneios funciona como uma árvore binária completa, ou seja, sempre com 2<sup>n</sup> elementos). Após a recursão, é feito um jogo entre os vencedores de cada lado do torneio.
```ruby
def rps_tournament_winner_a(matches)
  
  # If match is the first one (first in tournament branch)
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


## Questão 3
Para esta questão, era necessário implementar um método que, ao receber um array com strings, retornava um array de arrays que agrupavam strings que fossem anagramas uma das outras.

```ruby
# input:
['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams',
'scream']
# => output:
[["cars", "racs", "scar"], ["four"], ["for"], ["potatoes"], ["creams", "scream"]]
```
A solução consistiu em agrupar anagramas por meio do método ```group_by```, o qual cria um hash baseado no filtro descrito no bloco. Neste caso, o filtro foi palavras com exatamente as mesmas letras (independente da orde, se for um anagrama, terá as mesmas letras na mesma quantidade, então basta agrupar as palavras com base nas suas strings ordenadas com base nos seus caracteres - ``` chars.sort.join```, dado que não é possível usar um ```sort``` em strings). Após isso, irá retornar uma lista contendo os valores da hash, agrupados por suas chaves (geradas pelo ```group_by```) em uma lista.

```ruby
def combine_anagrams(words)
  words.group_by {|word| word.chars.sort.join}.values
end
```
## Questão 4
### Item A
Após fornecer a estrutura de uma classe Dessert, o enunciado pedia para construir dois métodos: um método ```healthy?``` que retornava ```true``` quando a sobremesa possuisse uma quantidade menor ou igual a 200 calorias; e um método ```delicious?```, que sempre retornaria ```true```. O resultado está a seguir:

```ruby
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
```  

Pelo código acima, é visível a criação de atributos de instância ```name``` e ```calories```, e, por meio do uso do ```attr_accessor```, é possível atribuir valores e obtê-los por fora da classe (mesmo não sendo utilizado nessa questão). Um método de inicialização foi escrito, o qual recebe o nome e as calorias e guarda na nova instância do objeto. Os métodos ```delicious?``` e ```healthy?```, em si, são bem simples, um só retornando ```true``` e o outro retornando o resultado da comparação ```calories < 200```.

### Item B
O segundo item requeria a criação da classe JellyBean que extendesse Dessert, gerando um getter e setter para o atributo sabor (```flavor```), e modificando o método ```delicious?``` para retornar ```false``` quando o sabor fosse ```black licorice```. Para isso, foi introduzido um accessor para ```flavor``` e, para ```delicious?```, a condição de retornar ```true``` apenas se ```flavor``` não fosse ```black licorice```, usando o operador ternário ```?```. A classe ficou como abaixo:

```ruby
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
```

Vale notar que, ao estudar com a LLM, foi explicado que, para o ```initialize```, não era necessário definir ```name``` e ```calories```, pois, como essa classe herdava de Dessert, bastava chamar o initialize de Dessert:

```ruby
def initialize(name, calories, flavor)
    @name = name               #  Não há necessidade de usar essas linhas,
    @calories = calories       #  pois Dessert já implementa-as em seu initialize
    @flavor = flavor
  end
```

## Questão 5
Para a questão 5, com o objetivo de treinar a metaprogramação, foi pedido para criar um histórico de uso do ```attr_accessor``` e dos valores passados para ele em uma determinada instância. A estrutura básica da classe foi fornecida pelo exercício, em que foi definido o método ```attr_accessor_with_history```, que, com o nome de um atributo, criava o getter para o seu valor e para o valor do seu histórico. Após isso, é chamado o class_eval, que era o dever do exercício. O resultado esperado seria como a seguir:

```ruby
f = Foo.new # => #<Foo:0x127e678>
f.bar = 3 # => 3
f.bar = :wowzo # => :wowzo
f.bar = 'boo!' # => 'boo!'
f.bar_history # => [nil, 3, :wowzo, 'boo!']
```

No começo, foi necessário pesquisar a documentação sobre ```class_eval``` para entender melhor do seu funcionamento. Com o uso da LLM, foi explicado que esse método faz parte da metaprogramação de Ruby, em que, dado uma string, será gerado um método dinamicamente durante a execução. Dessa forma, no momento em que fosse reconhecido o setter para um atributo qualquer, como o ```bar```, seria construido um método para esse atributo específico, algo que só seria possível fazer durante o tempo de execução, já que o método só saberá o nome do atributo no momento em que for passado para ele como argumento.

Assim, foi definido o método setter, dentro do ```attr_accessor_with_history```, que checa se o array contendo histórico sobre esse método existe ou não (checa se é ```nil```). Se não existir, cria um array com valor inicial ```[nil]```, insere o valor que o setter do atributo recebeu ao array e também passa o valor para o atributo. Dessa forma, ao usar um setter para guardar algum valor em ```bar```, da isntância ```f = Foo.new```, o seu valor é armazenado no array e, por isso, ao chamar o histórico, é retornado o array ```[nil, 3, :wowzo, 'boo!']```. 

```ruby
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
```
Ao estudar com um LLM, foi sugerido também o uso do `unless` ao invés do `if` para ficar mais idiomático:
```ruby
%q(
if @#{attr_name}_history == nil
  @#{attr_name}_history = [nil]
end
)
# substituir por
%q(
unless @#{attr_name}_history
  @#{attr_name}_history = [nil]
end
)
```

## Questão 6
### Item A
Continuando com a metaprogramação em Ruby, foi pedido para implementar o método `in` para a classe Numeric e os métodos de conversão de moedas, visto em sala de aula. O código abaixo foi fornecido nos slides da aula e na lista de exercícios, que definem um atributo de classe `currencies` como um hash, mostrando as taxas de convesão entre moedas, em relação ao dólar. Depois, o método `method_missing` é alterado para checar se o id recebido é alguma das moedas (no singular ou não, mas se estiver no plural, por meio do `gsub`, é retirado o "s" do final). Ainda nesse método, ele checa se esse id, agora sem o "s" do final e atribuido a uma variável (para não substituir o id em si), existe no hash de `currencies` ou não. Se existir, é feita uma conversão daquela moeda para dólares, se não existir, chama `super`, ou seja, chama o method_missing da sua superclasse, que irá procurar o método que não foi reconhecido pela classe Numeric, como o `method_missing` geralmente faz. Mais uma vez, o uso de um LLM agilizou o processo de entendimento do funcionamento do método `super` e de como o código funcionava.     

```ruby
class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}
  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
end
```

Após isso, o código acima foi extendido para comportar o método ```in```. Como visto em sala de aula, a melhor forma de realizar isso seria criar um método ```in``` na classe Numeric, que convertesse o valor, em dólares, para a moeda desejada. A estrutura é bem parecida, exceto que é dividido o valor em dólar pela taxa de conversão para uma moeda válida (que esteja no hash).

```ruby
class Numeric
  @@currencies = {'dollar' => 1, 'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}
  
  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
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
```

### Item B
O item B pretendia modificar o código para aceitar ```palindrome?``` como um método que pudesse ser chamado da forma ```"foo".palindrome?``` ao invés de como na questão 1 (```palindrome?("foo")```). Para isso, bastou inserir a definição da questão de ```palindrome?``` para a classe String. Não há muito o que comentar sobre o código em si, pois é a mesma estrutura da primeira questão. 

```ruby
class String
  def palindrome?()
    string = self.gsub(/\W/i,"").downcase.reverse
    string == string.reverse
  end
end
```

### Item C
Por fim, era necessário fazer com que ```palindrome?``` funcionasse com Enumerables (como arrays). Esse foi mais simples ainda, pois o algoritmo apenas necessitava comparar se a estrutura era igual ao seu inverso, ao contrário da questão que envolvia strings, que precisou de maior manipulação da string para obter o resultado do palíndromo. O uso de LLM foi útil nesse caso para o debug, dado que havia sido escrito ```class Enumerable``` como no item B foi escrito ```class String```, porém Enumerable é um módulo.

```ruby
module Enumerable
  def palindrome?()
    self == self.reverse
  end
end
```

## Conclusões
Apesar de ter uma fácil abertura para entrada, Ruby possui uma grande curva de conhecimento, principalmente nas suas expressões idiomáticas. O uso de LLM proporcionou uma facilidade em entender essas minúcias da linguagem, melhor entender a sintaxe e o significado de cada algoritmo e a debuggar quando não era obtido o resultado esperado. 

require './expression'
require './statement'

p Number.new(5).to_ruby
# => "-> e { 5 }"
p eval(Number.new(5).to_ruby).call({})
# => 5
p Boolean.new(false).to_ruby
# => "-> e { false }"
p eval(Boolean.new(false).to_ruby).call({})
# => false

expression = Variable.new(:x)
p expression
# => "<<x>>"
p expression.to_ruby
# => "-> e { e[:x] }"
p eval(expression.to_ruby).call({ x: 7 })
# => 7

p Add.new(Variable.new(:x), Number.new(1)).to_ruby
# => "-> e { -> e { e[:x] }.call(e) + -> e { 1 }.call(e) }"
p LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
# => "-> e { -> e { -> e { e[:x] }.call(e) + -> e { 1 }.call(e) }.call(e) < -> e { 3 }.call(e) }"
environment = { x: 3 }
proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
p proc.call(environment)
# => 4
proc = eval(p LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby)
p proc.call(environment)
# => false

statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
p statement.to_ruby
# => "-> e { e.merge( { :y => -> e { -> e { e[:x] }.call(e) + -> e { 1 }.call(e) }.call(e) } ) }"
proc = eval(statement.to_ruby)
p proc.call({ x: 3 })
# => {:x=>3, :y=>4}

statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)
p statement.to_ruby
# => "-> e { while(-> e { -> e { e[:x] }.call(e) < -> e { 5 }.call(e) }).call(e); e = -> e { e.merge( { :x => -> e { -> e { e[:x] }.call(e) * -> e { 3 }.call(e) }.call(e) } ) }.call(e); end; }"
proc = eval(statement.to_ruby)
p proc.call({ x: 1 })
# => {:x=>9}
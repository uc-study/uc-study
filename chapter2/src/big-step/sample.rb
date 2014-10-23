require './expression'
require './statement'

p Number.new(23).evaluate({})
# => <<23>>
p Variable.new(:x).evaluate({ x: Number.new(23) })
# => <<23>>
p LessThan.new(
    Add.new(Variable.new(:x), Number.new(2)),
    Variable.new(:y)
  ).evaluate({ x: Number.new(2), y: Number.new(5) })
# => <<true>>

puts '##### While #####'
statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)
p statement
p statement.evaluate({ x: Number.new(1) })
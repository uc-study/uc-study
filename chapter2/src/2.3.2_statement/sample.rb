require '../expression'
require '../statement'
require './vm'

statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
p statement
# => <<x = x + 1>>
environment = { x: Number.new(2) }
p environment
# => {:x=><<2>>}
p statement.reducible?
# => true
statement, environment = statement.reduce(environment)
p [statement, environment]
# => [<<x = 2 + 1>>, {:x=><<2>>}]
statement, environment = statement.reduce(environment)
p [statement, environment]
# => [<<x = 3>>, {:x=><<2>>}]
statement, environment = statement.reduce(environment)
p [statement, environment]
# => [<<do-nothing>>, {:x=><<3>>}]

puts '###### Assign #####'
Machine.new(
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
    { x: Number.new(2) }
).run

puts '##### If-else #####'
Machine.new(
    If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2))
    ),
    { x: Boolean.new(true) }
).run

puts '##### If-only-consequence #####'
Machine.new(
    If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        DoNothing.new
    ),
    { x: Boolean.new(true) }
).run

puts '##### Sequence #####'
Machine.new(
    Sequence.new(
        Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
        Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
    ),
    {}
).run

puts '##### While #####'
Machine.new(
    While.new(
        LessThan.new(Variable.new(:x), Number.new(5)),
        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
    ),
    { x: Number.new(1) }
).run
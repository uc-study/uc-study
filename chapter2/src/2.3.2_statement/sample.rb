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

# Assign
Machine.new(
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
    { x: Number.new(2) }
).run

# If
Machine.new(
    If.new(
        Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2))
    ),
    { x: Boolean.new(true) }
).run
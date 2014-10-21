require '../expression'
require './vm'

expression = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)

p expression
# => <<1 * 2 + 3 * 4>>

p Number.new(1).reducible?
# => false
p Add.new(Number.new(1), Number.new(2)).reducible?
# => true

expression = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)
p expression
# => <<1 * 2 + 3 * 4>>
p expression.reducible?
# => true
p expression = expression.reduce({})
# => <<2 + 3 * 4>>
p expression.reducible?
# true
p expression = expression.reduce({})
# => <<2 + 12>>
p expression.reducible?
# => true
p expression = expression.reduce({})
# => <<14>>
p expression.reducible?
# => false

Machine.new(
    Add.new(
        Multiply.new(Number.new(1), Number.new(2)),
        Multiply.new(Number.new(3), Number.new(4))
    )
).run

Machine.new(
    LessThan.new(Number.new(5), Add.new(Number.new(2), Number.new(2)))
).run

Machine.new(
    Add.new(Variable.new(:x), Variable.new(:y)),
    { x: Number.new(3), y: Number.new(4) }
).run

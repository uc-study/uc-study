require '../big-step/expression'
require '../big-step/statement'
require 'treetop'

# treetopファイルを読み込んでパーサを生成
p Treetop.load('simple')
# => SimpleParser

# パース関数
def parse(syntax)
  parser = SimpleParser.new
  parser_tree = parser.parse(syntax)
  unless parser_tree
    p parser.failure_reason
    p parser.failure_line
    p parser.failure_column
    raise 'Parse error.'
  end
  parser_tree
end

parser_tree = parse('while (x < 5) { x = x * 3 }')
statement = parser_tree.to_ast
p statement.class
# => While
p statement
# => <<while(x < 5) { x = x * 3 }>>

parser_tree = parse('if (false) { x = x * 3 } else { y = x + 3 }')
statement = parser_tree.to_ast
p statement.class
# => If
p statement
# => <<if(false) { x = x * 3 } else { y = x + 3 }>>
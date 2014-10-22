require '../big-step/expression'
require '../big-step/statement'
require 'treetop'

# treetopファイルを読み込んでパーサを生成
p Treetop.load('simple')
# => SimpleParser

# パース
parser_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')
statement = parser_tree.to_ast
p statement.class
# => While
p statement
# => <<while(x < 5) { x = x * 3 }>>

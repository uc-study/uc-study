require 'reg_exp'
require 'rubygems'
require 'treetop'
Treetop.load('pattern')

parse_tree = PatternParser.new.parse('ab*')

pattern = parse_tree.to_ast
puts pattern.matches?('ab')
puts pattern.matches?('abb')
puts pattern.matches?('abbb')
puts pattern.matches?('babb')

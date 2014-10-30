require 'reg_exp'

puts '# pattern'

##########################################################
pattern = 
    Repeat.new(
        Choose.new(
            Concatenate.new(Literal.new('a'), Literal.new('b')),
            Literal.new('a')
        )
    )
puts pattern

puts ''
##########################################################
puts '# empty'

nfa_design = Empty.new.to_nfa_design
puts '## input empty', nfa_design.accepts?('')
puts '## input a', nfa_design.accepts?('a')

puts ''
##########################################################
puts '# literal -> a'

nfa_design = Literal.new('a').to_nfa_design
puts '## input empty', nfa_design.accepts?('')
puts '## input a', nfa_design.accepts?('a')
puts '## input b', nfa_design.accepts?('b')

puts ''
##########################################################
puts '# concatenate'

pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
puts pattern.matches?('a')
puts pattern.matches?('ab')
puts pattern.matches?('abc')

puts ''
##########################################################
puts '# choose'
pattern = Choose.new(Literal.new('a'), Literal.new('b'))

puts pattern.matches?('a')
puts pattern.matches?('b')
puts pattern.matches?('c')

puts ''
##########################################################
puts '# repeat'
pattern = Repeat.new(Literal.new('a'))

puts pattern.matches?('')
puts pattern.matches?('a')
puts pattern.matches?('aaaa')
puts pattern.matches?('b')

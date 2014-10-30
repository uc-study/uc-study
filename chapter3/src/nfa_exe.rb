require 'nfa'

rulebook = NFARulebook.new([
    FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
    FARule.new(2, 'a', 3), FARule.new(2, 'b', 3), 
    FARule.new(3, 'a', 4), FARule.new(3, 'b', 4),
])

puts '# rulebook'
state = rulebook.next_states(Set[1], 'b')
puts 'states is '
state.each { |state| puts state }
# ==> {1, 2}

state = rulebook.next_states(Set[1, 2], 'a')
puts 'states is '
state.each { |state| puts state }
# ==> {1, 3}

state = rulebook.next_states(Set[1, 3], 'b')
puts 'states is '
state.each { |state| puts state }
# ==> {1, 2, 4}

puts ''
######################################################################
puts '# NFA'

accepting = NFA.new(Set[1], [4], rulebook).accepting?
puts 'accepting is ' + accepting.to_s

accepting = NFA.new(Set[1, 2, 4], [4], rulebook).accepting?
puts 'accepting is ' + accepting.to_s

nfa = NFA.new(Set[1], [4], rulebook)
accepting = nfa.accepting?
puts 'accepting is ' + accepting.to_s

nfa.read_string('bbbbb')
accepting = nfa.accepting?
puts 'accepting is ' + accepting.to_s

puts ''
######################################################################
puts '# NFA Design'

nfa_design = NFADesign.new(1, [4], rulebook)

accepting = nfa_design.accepts?('bab')
puts 'accepting is ' + accepting.to_s

accepting = nfa_design.accepts?('bbbbb')
puts 'accepting is ' + accepting.to_s

accepting = nfa_design.accepts?('bbabb')
puts 'accepting is ' + accepting.to_s

puts ''
######################################################################
puts '# free move'

rulebook = NFARulebook.new([
    FARule.new(1, nil, 2), FARule.new(1, nil, 4),
    FARule.new(2, 'a', 3), 
    FARule.new(3, 'a', 2),
    FARule.new(4, 'a', 5),
    FARule.new(5, 'a', 6),
    FARule.new(6, 'a', 4),
])

rulebook.next_states(Set[1], nil)
state = rulebook.follow_free_moves(Set[1])
puts 'states is '
state.each { |state| puts state }

nfa_design = NFADesign.new(1, [2, 4], rulebook)
puts nfa_design.accepts?('aa')
puts nfa_design.accepts?('aaa')
puts nfa_design.accepts?('aaaaa')
puts nfa_design.accepts?('aaaaaa')

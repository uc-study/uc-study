class FARule < Struct.new(:state, :character, :next_state)
    def applies_to?(state, character)
        self.state == state && self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule # {state.inspect} --# {character} --> #{next_state.inspect}>"
    end
end

class DFARulebook < Struct.new(:rules)
    def next_state(state, character)
        rule_for(state, character).follow
    end

    def rule_for(state, character)
        rules.detect { |rule| rule.applies_to?(state, character) }
    end
end

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
    def accepting?
        accept_states.include?(current_state)
    end

    def read_character(character)
        self.current_state = rulebook.next_state(current_state, character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

class DFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    def to_dfa
        DFA.new(start_state, accept_states, rulebook)
    end

    def accepts?(string)
        to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
    end
end

######################################################################
rulebook = DFARulebook.new([
   FARule.new(1, 'a', 2) , FARule.new(1, 'b', 1),
   FARule.new(2, 'a', 2) , FARule.new(2, 'b', 3),
   FARule.new(3, 'a', 3) , FARule.new(3, 'b', 3)
])

puts '# rulebook'
next_state = rulebook.next_state(1, 'a')
puts 'next_state is ' +  next_state.to_s
# ==> 2

next_state = rulebook.next_state(1, 'b')
puts 'next_state is ' +  next_state.to_s
# ==> 1

next_state = rulebook.next_state(2, 'b')
puts 'next_state is ' +  next_state.to_s
# ==> 3

puts ''
######################################################################
puts '# DFA'
accepting = DFA.new(1, [1, 3], rulebook).accepting?
puts 'accepting is ' +  accepting.to_s
# ==> true

accepting = DFA.new(1, [3], rulebook).accepting?
puts 'accepting is ' +  accepting.to_s
# ==> false

puts ''
######################################################################
puts '# input character'
dfa = DFA.new(1, [3], rulebook); dfa.accepting?

# 'b'を入力
puts '## input b'
state = dfa.read_character('b')
accepting = dfa.accepting?
puts 'state is ' +  state.to_s
puts 'accepting is ' +  accepting.to_s
# ==> false

# 'a'を3回入力
puts '## input aaa'
3.times do state = dfa.read_character('a') end
accepting = dfa.accepting?
puts 'state is ' +  state.to_s
puts 'accepting is ' +  accepting.to_s
# ==> false

# 'b'を入力
puts '## input b'
state = dfa.read_character('b')
accepting = dfa.accepting?
puts 'state is ' +  state.to_s
puts 'accepting is ' +  accepting.to_s
# ==> true

puts ''
######################################################################
puts '# input string'
dfa = DFA.new(1, [3], rulebook)

puts '## input baaab'
dfa.read_string('baaab')
accepting = dfa.accepting?
puts 'accepting is ' +  accepting.to_s
# ==> true

puts ''
######################################################################
puts '# DFA Design'
dfa_design = DFADesign.new(1, [3], rulebook)

puts '## input a'
accepting = dfa_design.accepts?('a')
puts 'accepting is ' +  accepting.to_s
# ==> false

puts '## input baa'
accepting = dfa_design.accepts?('baa')
puts 'accepting is ' +  accepting.to_s
# ==> false

puts '## input baba'
accepting = dfa_design.accepts?('baba')
puts 'accepting is ' +  accepting.to_s
# ==> true

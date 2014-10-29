require 'set'

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


class NFARulebook < Struct.new(:rules)
    def next_states(states, character)
        states.map { |state| follow_rurles_for(state, character) }.flatten(1).to_set
    end

    def follow_rurles_for(state, character)
        rules_for(state, character).map(&:follow)
    end

    def rules_for(state, character)
        rules.select { |rule| rule.applies_to?(state, character) }
    end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
    def accepting?
        (current_states & accept_states).any?
    end

    def read_character(character)
        self.current_states = rulebook.next_states(current_states, character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    def accepts?(string)
        to_nfa.tap{ |nfa| nfa.read_string(string) }.accepting?
    end

    def to_nfa
        NFA.new(Set[start_state], accept_states, rulebook)
    end
end

######################################################################
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

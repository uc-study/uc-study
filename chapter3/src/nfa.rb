# 重複した状態をもつ必要がないためSetで状態を管理
require 'set'
require 'dfa'

# 非決定性有限オートマトンの規則集
class NFARulebook < Struct.new(:rules)
    # 次の状態がどうなるか
    def next_states(states, character)
        states.map { |state| follow_rurles_for(state, character) }.flatten(1).to_set
    end

    # 次になりうる状態
    def follow_rurles_for(state, character)
        rules_for(state, character).map(&:follow)
    end

    # 適用可能な規則を抽出
    def rules_for(state, character)
        rules.select { |rule| rule.applies_to?(state, character) }
    end

    # 自由移動
    def follow_free_moves(states)
        more_states = next_states(states, nil)

        if more_states.subset?(states)
            states
        else
            follow_free_moves(states + more_states)
        end
    end

    # どんな文字を読めるか
    def alphabet
        rules.map(&:character).compact.uniq
    end
end

# NFA
class NFA < Struct.new(:current_states, :accept_states, :rulebook)
    # 受理状態か
    def accepting?
        (current_states & accept_states).any?
    end

    # 文字を読み込む
    def read_character(character)
        self.current_states = rulebook.next_states(current_states, character)
    end

    # 文字列を読み込む
    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end

    # 現在の状態
    def current_states
        rulebook.follow_free_moves(super)
    end
end

# NFAデザイン
class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    # 受理状態か
    def accepts?(string)
        to_nfa.tap{ |nfa| nfa.read_string(string) }.accepting?
    end

    # NFAに変換
    def to_nfa(current_states = Set[start_state])
        NFA.new(current_states, accept_states, rulebook)
    end
end

# NFAシミュレーター
class NFASimulation < Struct.new(:nfa_design)
    # 次の状態
    def next_state(state, character)
        nfa_design.to_nfa(state).tap { |nfa|
            nfa.read_character(character)
        }.current_states
    end

    # 適用可能な規則を抽出
    def rules_for(state)
        nfa_design.rulebook.alphabet.map { |character|
            FARule.new(state, character, next_state(state, character))
        }
    end

    # 状態と規則を再帰的に探す
    def discover_states_and_rules(states)
        rules = states.map { |state| rules_for(state) }.flatten(1)
        more_states = rules.map(&:follow).to_set

        if more_states.subset?(states)
            [states, rules]
        else
            discover_states_and_rules(states + more_states)
        end
    end

    # DFAに変換
    def to_dfa_design
        start_state = nfa_design.to_nfa.current_states
        states, rules = discover_states_and_rules(Set[start_state])
        accept_states = states.select { |state| nfa_design.to_nfa(state).accepting? }

        DFADesign.new(start_state, accept_states, DFARulebook.new(rules))
    end
end

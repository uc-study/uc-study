# 有限オートマトンの規則
class FARule < Struct.new(:state, :character, :next_state)
    # 規則が適用できるか
    def applies_to?(state, character)
        self.state == state && self.character == character
    end

    # 次の状態
    def follow
        next_state
    end

    def inspect
        "#<FARule # {state.inspect} --# {character} --> #{next_state.inspect}>"
    end
end

# 決定性有限オートマトンの規則集
class DFARulebook < Struct.new(:rules)
    # 次の状態がどうなるか
    def next_state(state, character)
        rule_for(state, character).follow
    end

    # 適用可能な規則を1つだけ抽出
    def rule_for(state, character)
        rules.detect { |rule| rule.applies_to?(state, character) }
    end
end

# DFA
class DFA < Struct.new(:current_state, :accept_states, :rulebook)
    # 受理状態か
    def accepting?
        accept_states.include?(current_state)
    end

    # 文字を読み込む
    def read_character(character)
        self.current_state = rulebook.next_state(current_state, character)
    end

    # 文字列を読み込む
    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

# DFAデザイン
class DFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    # DFAの生成
    def to_dfa
        DFA.new(start_state, accept_states, rulebook)
    end

    # 受理状態か
    def accepts?(string)
        # tap関数をつかうことでローカル変数を節約
        to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
    end
end

class Number < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{value.inspect} }"
  end
end

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end

# 足し算、左と右を再帰的に評価した結果を足す
class Add < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{left.to_ruby}.call(e) + #{right.to_ruby}.call(e) }"
  end
end

# かけ算、左と右を再帰的に評価した結果をかける
class Multiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{left.to_ruby}.call(e) * #{right.to_ruby}.call(e) }"
  end
end

# 小なり演算子、左と右を再帰的に評価した結果を評価する
class LessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{left.to_ruby}.call(e) < #{right.to_ruby}.call(e) }"
  end
end
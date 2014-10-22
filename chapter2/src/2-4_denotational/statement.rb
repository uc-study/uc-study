class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    environment.merge( { name => expression.evaluate(environment) } )
  end

  def to_ruby
    "-> e { e.merge( { #{name.inspect} => #{expression.to_ruby}.call(e) } ) }"
  end
end

class DoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    environment
  end

  def to_ruby
    '-> e { e }'
  end
end

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if(#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    case condition.evaluate(environment)
      when Boolean.new(true)
        consequence.evaluate(environment)
      when Boolean.new(false)
        alternative.evaluate(environment)
    end
  end

  def to_ruby
    "-> e { if(#{condition.to_ruby}).call(e) then #{consequence.to_ruby}.call(e) else #{alternative.to_ruby}.call(e) end }"
  end
end

# firstの評価結果の環境をsecondに引き継ぐ
class Sequence < Struct.new(:left, :right)
  def to_s
    "#{first}; #{second}"
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    second.evaluate(first.evaluate(environment))
  end

  def to_ruby
    "-> e { #{second.to_ruby}.call(#{first.to_ruby}.call(e)) }"
  end
end

class While < Struct.new(:condition, :body)
  def to_s
    "while(#{condition}) { #{body} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    case condition.evaluate(environment)
      when Boolean.new(true)
        evaluate(body.evaluate(environment))
      when Boolean.new(false)
        environment
    end
  end

  def to_ruby
    "-> e { while(#{condition.to_ruby}).call(e); e = #{body.to_ruby}.call(e); end; e }"
  end
end
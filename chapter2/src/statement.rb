# 何もしない文、プログラムが完了した場合この簡約が実行される
class DoNothing
  def to_s
    'do-nothing'
  end

  def inspect
    "<<#{self}>>"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end

# 代入を表現する
class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({ name => expression })]
    end
  end
end

# If文を表現する
class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if(#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if condition.reducible?
      [If.new(condition.reduce(environment, consequence, alternative), environment)]
      [consequence, environment]
    else
      case condition
        when Boolean.new(true)
          [consequence, environment]
        when Boolean.new(false)
          [alternative, environment]
      end
    end
  end
end
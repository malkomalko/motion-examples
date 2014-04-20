class Object

  def class_ivar(var)
    self.class.instance_variable_get("@#{var}".to_sym)
  end

end

module Foo

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def foo_method(value)
      @foo_method = value
    end

  end
end

class BarOne

  include Foo
  foo_method :bar_one

end

class BarTwo

  include Foo
  foo_method :bar_two

end

bar_one = BarOne.new
bar_two = BarTwo.new

bar_one.class_ivar('foo_method')
bar_two.class_ivar('foo_method')
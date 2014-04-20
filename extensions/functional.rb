module RMExtensions
  module Functional

    def prop(key)
      ->(obj) { obj[key] }
    end

    def eql(key, val = nil)
      val ? ->(obj) { obj[key] == val } : ->(obj) { obj == key }
    end

    def inc(key, array = [])
      ->(obj) { array.include?(obj[key]) }
    end

  end
end
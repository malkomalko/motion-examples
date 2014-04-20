module RMExtensions
  module JsonKit

    def initialize(opts = {})
      setValuesForKeysWithDictionary(opts) if opts.is_a?(Hash)
    end

    def setValue(value, forUndefinedKey:key); end

    def to_hash
      instance_variables.reduce({}) do |memo, iv|
        memo[iv[1..-1].to_sym] = instance_variable_get(iv)
        memo
      end
    end

  end
end
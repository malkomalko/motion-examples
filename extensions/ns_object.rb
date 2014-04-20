class NSObject

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def blank_or_zero?
    blank? || self == 0 || self == 0.0
  end

  def present?
    !blank?
  end

  def bind(bindings)
    if bindings && bindings.is_a?(Hash)
      bindings.each do |k,v|
        if self.respond_to?(k.to_sym)
          self.send("#{k.to_s}=", v)
        end
      end
    end
  end

  def safe(method_chain)
    methods = method_chain.split('.')
    obj = self

    methods.each do |method|
      obj = obj.respond_to?(method.to_sym) ? obj.send(method.to_sym) : nil
      return nil unless obj
    end

    obj
  end

  def try(attribute, default = '')
    if self.is_a?(Hash)
      value = self[attribute.to_sym]
      value = self[attribute.to_s] if value.nil?
    else
      value = self.send(attribute.to_sym)
    end

    value.blank_or_zero? ? default : value
  end

end
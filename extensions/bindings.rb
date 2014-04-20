module RMExtensions
  module Bindings

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def bindings_for(obj, &block)
        @__bindings__ ||= {}
        @__bindings__[self.to_s] ||= {}
        @__bindings__[self.to_s][obj.to_sym] ||= block
      end

    end

    def bindings
      @__bindings__
    end

    def viewWillAppear(animated)
      super

      bindings = self.class.instance_variable_get(:@__bindings__)
      return if bindings.nil?
      @__bindings__ = bindings[self.class.to_s]
    end

    def apply_bindings(instance = self)
      @__bindings__.each do |obj, block|
        @current_binding = self.send(obj.to_sym)
        next if @current_binding.nil?
        instance.instance_eval(&block)
      end

      @current_binding = nil
    end

    def binding(view, opts = {})
      prop = opts[:to] || view.to_sym
      type = opts[:type] || :text
      default = opts[:default] || view.to_s.capitalize
      format = opts[:format] || '%s'
      folder = opts[:folder]
      photo_type = opts[:photo_type]

      view = self.send(view)
      return if view.nil?

      value = @current_binding.try(prop.to_s, default)

      case type.to_sym
      when :int
        view.text = value == default ?
          format % [default.to_i.to_s] : format % [value.to_i.to_s]
      when :photo
        return unless view.is_a?(UIImageView)

        view.async_download_and_cache_image({
          value: value, default: default, format: format,
          folder: folder, photo_type: photo_type
        })
      when :price
        view.text = value == default ? default :
          value.to_i.to_s.formatted_price('$')
      when :strip_decimals
        view.text = value == default ? default :
          format % [value.strip_decimals_when_zero.to_s]
      when :text
        view.text = format % [value.to_s]
      end
    end

  end
end
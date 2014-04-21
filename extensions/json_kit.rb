# Use Dish: https://github.com/lassebunk/dish

module RMExtensions
  module JsonKit

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def from_json(json)
        if json.is_a?(Hash)
          json = [json]
        end
        return [] if json.blank? || !json.is_a?(Array)
        Dish(json, self)
      end

    end

  end
end
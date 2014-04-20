class Foo

  include RMExtensions::JsonKit

  def self.from_json(json)
    if json.is_a?(Hash)
      json = [json]
    end
    return [] if json.blank? || !json.is_a?(Array)
    json.map { |item| new(item) }
  end

end
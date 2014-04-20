class Foo

  include RMExtensions::JsonKit

  def self.from_json(json)
    json.map { |item| new(item) }
  end

end
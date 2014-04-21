class Foo < Dish::Plate

  include RMExtensions::JsonKit

end

# Below will get converted to real Foo objects
# See https://github.com/lassebunk/dish
Foo.from_json(array_or_hash)
class Foo
  def initialize(params = {})
  end

  def update(params = {})
    self
  end

  def delete
  end

  def save
    true
  end

  class << self
    def create(params = {})
      Foo.new(params).tap do |foo|
        foo.save
      end
    end

    def find(id_or_params)
    end

    def all
      Foo.find(:all)
    end
  end
end

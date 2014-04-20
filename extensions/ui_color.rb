class UIColor

  def self.random
    colorWithRed(Random.rand, green:Random.rand, blue:Random.rand, alpha:1)
  end

end
class NSNumber

  def strip_decimals_when_zero
    self % 1 == 0.0 ? self.to_i : self
  end

end
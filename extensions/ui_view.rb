class UIView

  def x
    frame.origin.x
  end

  def x=(size)
    self.frame = [[size,y],[width,height]]
  end

  def y
    frame.origin.y
  end

  def y=(size)
    self.frame = [[x,size],[width,height]]
  end

  def width
    frame.size.width
  end

  def width=(size)
    self.frame = [[x,y],[size,height]]
  end

  def height
    frame.size.height
  end

  def height=(size)
    self.frame = [[x,y],[width,size]]
  end

  def border_radius(radius)
    layer.cornerRadius = radius
  end

  def border_shadow(opts = {})
    layer.shadowColor = UIColor.blackColor.CGColor
    layer.shadowOpacity = opts[:opacity] || 0.5
    layer.shadowOffset = CGSizeMake(0.0, 1.0)
    layer.shadowRadius = opts[:radius] || 1.0

    layer.shadowPath = UIBezierPath.bezierPathWithRoundedRect(bounds,
      cornerRadius:layer.cornerRadius).CGPath
  end

end
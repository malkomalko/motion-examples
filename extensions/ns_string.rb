class NSString

  def decode_string
    stringByReplacingOccurrencesOfString('+', withString:' ').
      stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
  end

  def numbers
    chars_to_remove = NSCharacterSet.decimalDigitCharacterSet.invertedSet
    self.componentsSeparatedByCharactersInSet(
      chars_to_remove).componentsJoinedByString('')
  end

  def formatted_price(symbol = '')
    formatter = NSNumberFormatter.alloc.init
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4
    formatter.numberStyle = NSNumberFormatterDecimalStyle
    formatter.maximumFractionDigits = 0
    formatter.currencySymbol = symbol
    "#{symbol}#{formatter.stringFromNumber(self.numbers.to_i)}"
  end

  def replace_in_range(range, string)
    new_string = NSMutableString.stringWithString(self)
    new_string.replaceCharactersInRange(range, withString:string)
  end

  def titleize
    downcase.split(' ').map { |w| w.capitalize }.join(' ')
  end

  def tiled_image
    UIColor.colorWithPatternImage(self.uiimage)
  end

  def uiimage
    UIImage.imageNamed(self).tap do |retval|
      NSLog("No image named #{self}") unless retval
    end
  end

  def uiimageview
    self.uiimage.uiimageview
  end

end
class NSString

  def decode_string
    stringByReplacingOccurrencesOfString('+', withString:' ').
      stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
  end

  def download_image_from_s3(opts = {}, &block)
    format = opts[:format] || '%s'

    photo_with_dashes = self.gsub('%2F', '/')
    base_file_name = photo_with_dashes.split('/')[-1]
    photo = format % [base_file_name.to_s]
    image = UIImage.from_caches_path(photo, opts[:folder])

    if image.nil?
      opts = { image_url: self, file_name: photo, folder: opts[:folder] }
      RMExtensions::Queue.async_save_image_from_url(opts) do |img|
        block[img]
      end
    else
      block[image]
    end
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

  def photo_url_for_type(type)
    return self if type.nil?
    split(/\.jpg$/)[0] + "_#{type}.jpg"
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
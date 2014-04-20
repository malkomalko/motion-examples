class UIImage

  def self.from_caches_path(photo, subfolder = nil)
    if subfolder.nil?
      photo_on_disk = '%s/%s' % [App.caches_path, photo]
    else
      photo_on_disk = '%s/%s/%s' % [App.caches_path, subfolder, photo]
    end

    UIImage.imageWithContentsOfFile(photo_on_disk)
  end

  def self.from_url(url)
    image_url = NSURL.URLWithString(url)
    image_data = NSData.dataWithContentsOfURL(image_url)
    UIImage.imageWithData(image_data)
  end

  def create_thumb(size)
    main_image_view = UIImageView.alloc.initWithImage(self)
    width_greater_than_height = self.size.width > self.size.height
    side = width_greater_than_height ? self.size.height : self.size.width
    clipped_rect = CGRectMake(0, 0, side, side)

    UIGraphicsBeginImageContext(CGSizeMake(size, size))
    context = UIGraphicsGetCurrentContext()
    CGContextClipToRect(context, clipped_rect)
    scale_factor = size / side

    if width_greater_than_height
      tx = -((self.size.width - side) / 2) * scale_factor
      CGContextTranslateCTM(context, tx, 0)
    else
      ty = -((self.size.height - side) / 2) * scale_factor
      CGContextTranslateCTM(context, 0, ty)
    end

    CGContextScaleCTM(context, scale_factor, scale_factor)
    main_image_view.layer.renderInContext(context)

    thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    thumbnail
  end

  def jpeg(quality = 0.8)
    UIImageJPEGRepresentation(self, quality)
  end

  def resize_within(size)
    w = self.size.width
    h = self.size.height

    return self if [w,h].max <= size

    if w > h
      new_size = CGSizeMake(size, size / (w / h))
    end
      new_size = CGSizeMake(size / (h / w), size)
    else

    UIGraphicsBeginImageContext(new_size)
    drawInRect(CGRectMake(0, 0, new_size.width, new_size.height))
    image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    image
  end

  def save_to_caches_path(key, subfolder = nil)
    if subfolder.nil?
      path = "#{App.caches_path}/#{key}.jpg"
    else
      path = "#{App.caches_path}/#{subfolder}/#{key}.jpg"
    end

    error_ptr = Pointer.new(:object)
    mask = NSDataWritingAtomic
    self.jpeg.writeToFile(path, options:mask, error:error_ptr)
  end

end
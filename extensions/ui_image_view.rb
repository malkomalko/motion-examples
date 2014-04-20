class UIImageView

  def async_download_and_cache_image(opts = {})
    format = opts[:format] || '%s'
    return self.image = nil if opts[:value].nil?
    is_default = opts[:default] == opts[:value]

    if opts[:value].blank?
      if opts[:default].is_a?(String) && opts[:default].start_with?('http')
        key = opts[:default].photo_url_for_type(opts[:photo_type])
        RMExtensions::Queue.async_image_from_url(key) do |img_data|
          self.image = UIImage.imageWithData(img_data)
        end
        return
      elsif opts[:default].is_a?(String)
        return self.image = opts[:default].uiimage
      else
        return self.image = nil
      end
    end

    if opts[:value].is_a?(Array)
      img_url = opts[:value][0]
      key = img_url.photo_url_for_type(opts[:photo_type])
    elsif opts[:value].is_a?(String)
      img_url = opts[:value]
      key = img_url.photo_url_for_type(opts[:photo_type])

      if is_default
        return self.image = img_url.uiimage unless img_url.start_with?('http')
      else
        return self.image = key.uiimage unless key.start_with?('http')
      end
    else
      return self.image = nil
    end

    key.download_image_from_s3({
      format: format, folder: opts[:folder]
    }) do |image|
      self.image = image
    end
  end

end
class UITableView

  attr_accessor :cached_images

  def image_from_url(url, image_view, index_path)
    key = "#{index_path.section}:#{index_path.row}"
    @cached_images ||= {}
    cached_image_data = @cached_images[key]

    if cached_image_data
      image_view.image = UIImage.imageWithData(cached_image_data)
    else
      RMExtensions::Queue.async_image_from_url(url) do |image_data|
        return if image_data.nil?
        @cached_images[key] = image_data

        row = NSArray.arrayWithObject(index_path)
        animation = UITableViewRowAnimationNone
        reloadRowsAtIndexPaths(row, withRowAnimation:animation)
      end
    end
  end

end
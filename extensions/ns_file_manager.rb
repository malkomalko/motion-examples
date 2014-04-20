class NSFileManager

  def self.create_path(path)
    fm = NSFileManager.defaultManager

    unless fm.fileExistsAtPath(path)
      fm.createDirectoryAtPath(path,
        withIntermediateDirectories:false, attributes:nil, error:nil)
    end
  end

  def self.delete_files(opts = {})
    minutes = opts[:minutes_in_seconds] || 60*60*24*7
    base_path = opts[:path] || App.caches_path

    fm = NSFileManager.defaultManager
    enum = fm.enumeratorAtPath(base_path)
    return if enum.nil?

    files_to_delete = []

    while file = enum.nextObject
      path = "#{base_path}/#{file}"
      file_attributes = fm.attributesOfItemAtPath(path, error:nil)
      mod_date = file_attributes[NSFileCreationDate]

      if mod_date
        date_window = mod_date.dateByAddingTimeInterval(minutes)

        if NSDate.date.compare(date_window) == NSOrderedDescending
          files_to_delete << path
        end
      end
    end

    files_to_delete.each do |f|
      fm.removeItemAtPath(f, error:nil)
    end
  end

end
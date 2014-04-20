module RMExtensions
  module Queue

    module_function

    def async_http(&request)
      job = -> do
        run_loop = NSRunLoop.currentRunLoop
        request.call
        run_loop.run
      end

      thread = NSThread.alloc.initWithTarget(job,
        selector:'call', object:nil)
      thread.start
    end

    def async_image_from_url(url, &block)
      App.queue.async {
        image_data = NSData.from_url(url)
        App.main_queue.async { block[image_data] }
      }
    end

    def async_save_image_from_url(opts = {}, &block)
      image_url = opts[:image_url]
      folder = opts[:folder]
      file_name = opts[:file_name]

      App.queue.async {
        image = UIImage.from_url(image_url)

        if image.nil?
          App.main_queue.async { block[image] }
        else
          key = file_name.chomp(File.extname(file_name))
          path = "#{App.caches_path}/#{folder}"
          NSFileManager.create_path(path) unless folder.nil?
          image.save_to_caches_path(key, folder)
          App.main_queue.async { block[image] }
        end
      }
    end

  end
end
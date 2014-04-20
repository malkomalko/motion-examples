module RMExtensions
  module Camera

    module_function

    def make_nice_keys(info)
      callback_info = {}

      info.keys.each do |k|
        nice_key = k.gsub('UIImagePickerController', '').underscore.to_sym
        callback_info[nice_key] = info[k]
        info.delete k
      end

      callback_info
    end

  end
end
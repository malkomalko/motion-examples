module RMExtensions
  module Delegates
    module UITextField

      def textField(textField, shouldChangeCharactersInRange:range,
                    replacementString:string)
        if respondsToSelector('text_should_be_changed:')
          text_should_be_changed(textField, range, string)
        end
      end

    end
  end
end
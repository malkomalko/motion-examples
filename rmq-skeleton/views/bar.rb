class Bar < UIView

  def rmq_build

    rmq.apply_style :bar

    # Add subviews here, like so:
    #rmq.append(UILabel, :some_label)

  end

end


# To style this view include its stylesheet at the top of each controller's 
# stylesheet that is going to use it:
#   class SomeStylesheet < ApplicationStylesheet 
#     include BarStylesheet

# Another option is to use your controller's stylesheet to style this view. This
# works well if only one controller uses it. If you do that, delete the 
# view's stylesheet with:
#   rm app/stylesheets/views/bar.rb

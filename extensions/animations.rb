module RMExtensions
  module Animation

    def animate(duration, &block)
      UIView.animateWithDuration(duration, animations:block)
    end

  end
end
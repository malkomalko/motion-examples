class UINavigationController

  def by_class(klass)
    viewControllers.find { |c| c.class == klass }
  end

end
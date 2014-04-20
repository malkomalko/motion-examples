class UINavigationController

  def by_class(klass)
    viewControllers.find { |c| c.class == klass }
  end

  def push(view_controller)
    self.pushViewController(view_controller, animated:true)
    self
  end

  def pop(to_vc = nil)
    if to_vc == :root
      self.popToRootViewControllerAnimated(true)
    elsif to_vc
      self.popToViewController(to_vc, animated:true)
    else
      self.popViewControllerAnimated(true)
    end
  end

end
class UITabBarController

  def push(view_controller)
    view_controllers = []
    if self.viewControllers
      view_controllers += self.viewControllers
    end
    view_controllers << view_controller
    self.setViewControllers(view_controllers, animated:true)
    self
  end

end
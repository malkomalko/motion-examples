class UIViewController

  include RMExtensions::Events

  def viewWillDisappear(animated)
    remove_events unless @__event_listeners__.blank?
  end

  def push(view_controller)
    self.addChildViewController(view_controller)
    self
  end

  def <<(view_controller)
    push view_controller
  end

  def pop
    to_pop = self.childViewControllers[-1]
    if to_pop
      to_pop.removeFromParentViewController
    end
  end

end
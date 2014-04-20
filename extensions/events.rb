module RMExtensions
  module Events

    def on(event, &callback)
      @__event_listeners__ ||= []

      e = App.notification_center.observe(event) do |notification|
        payload = notification.safe('object') || {}
        callback[payload]
      end

      @__event_listeners__ << e
      e
    end

    def off(event)
      App.notification_center.unobserve event
    end

    def emit(event, args = {})
      App.notification_center.post(event, args)
    end

    def remove_events
      @__event_listeners__.each { |event| off(event) }
    end

  end
end
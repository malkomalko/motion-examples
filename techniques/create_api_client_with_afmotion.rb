module API
  module Client

    module_function

    # ENV['base_url'] = 'http://localhost:8000/'
    def client
      @client ||= AFMotion::SessionClient.build(ENV['base_url']) do
        session_configuration :default
        header 'Accept', 'application/json'
        response_serializer :json
      end

      add_auth_headers

      @client
    end

    def get(url, &callback)
      return unless online?
      client.get(url) { |res| callback(res, callback) }
    end

    def post(url, params = {}, &callback)
      return unless online?
      client.post(url, params) { |res| callback(res, callback) }
    end

    def put(url, params = {}, &callback)
      return unless online?
      client.put(url, params) { |res| callback(res, callback) }
    end

    def delete(url, params = {}, &callback)
      return unless online?
      client.delete(url, params) { |res| callback(res, callback) }
    end

    # example of authenticating requests
    def add_auth_headers
      @client.headers['Auth-Email'] = '...'
      @client.headers['Auth-Token'] = '...'
    end

    def callback(res, callback)
      if res.success?
        callback[nil, res.object || {}]
      elsif res.failure?
        callback[res.error.localizedDescription, {}]
      end
    end

    # use Reachability to check for internet
    def online?
      r = Reachability.reachabilityForInternetConnection
      !(r.currentReachabilityStatus == NotReachable)
    end

  end
end
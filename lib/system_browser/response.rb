module SystemBrowser
  class Response
    def initialize(data: nil, action: nil, resource: nil)
      @response = {
        callback_id: nil,
        system_browser_client: {
          action: action,
          data: data,
          resource: resource
        }
      }
    end

    def set_callback_id(callback_id)
      @response[:callback_id] = callback_id
    end

    def to_json
      JSON.generate(@response) + "\n"
    end
  end
end

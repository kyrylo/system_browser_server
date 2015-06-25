module SystemBrowser
  class AbstractResponse
    def initialize(data: nil, action: nil, resource: nil)
      @response = {
        system_browser_client: {
          action: action,
          data: data,
          resource: resource
        }
      }
    end

    def to_json
      JSON.generate(@response) + "\n"
    end
  end

  class Response < AbstractResponse
  end
end

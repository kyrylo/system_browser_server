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

  class GemAllResponse < AbstractResponse
    def initialize(data: nil, action: nil)
      super(data)

      @response[:data] = [
        'ruby-core',
        'ruby-stdlib',

      ]
      @response[:system_browser_client][:data] = [
        *GemList.new.serialize
      ]
    end
  end
end

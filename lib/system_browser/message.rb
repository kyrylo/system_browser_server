module SystemBrowser
  class Message
    def initialize(endpoint)
      @payload = {
        payload: {
          command: nil,
          data: nil
        }
      }

      @endpoint = endpoint
    end

    def send(data)
      @payload[:payload][:command] = @command
      @payload[:payload][:data] = data
      @endpoint.puts(JSON.generate(@payload))
    end
  end
end

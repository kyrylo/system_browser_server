module SystemBrowser
  class Session
    def initialize
      @connection = nil
      @request = nil
      @resources = [
        Resources::Gem,
        Resources::Behaviour,
        Resources::Method,
        Resources::Source
      ]
    end

    def connection=(connection)
      resp = Response.new(action: 'init')
      connection.puts(resp.to_json)

      @connection = connection
    end

    def process_request(request)
      request.process
      @request = request
    end

    def process_response
      @resources.each do |resource|
        if resource.name == @request.resource
          data = resource.new.__send__(@request.action, @request.scope, @request.other)

          response = Response.new(
            action: "add:#{@request.resource}:#{@request.scope}",
            data: data)

          @connection.puts(response.to_json)
          return
        end
      end
    end
  end
end

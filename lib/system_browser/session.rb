module SystemBrowser
  class Session
    def initialize
      @connection = nil
      @request = nil
      @resources = [Resources::Gem, Resources::Behaviour]
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
          data = resource.new.__send__(@request.action, @request.scope)

          response = Response.new(
            action: "add:#{@request.resource}:#{@request.scope}",
            data: data)

          @connection.puts(response.to_json)
          return
        end
      end
    end

    protected

    def process(request, connection)
      req = request.chop.split
      data = req[1..-1].join

      case req.first
      when 'GET_BEHAVIORS'

      when 'GET_METHODS'
        sn = SystemNavigation.default
        method_hash = sn.all_methods_in_behavior(eval(data))
        methods = method_hash.as_array.map(&:name)
        Message::AddMethodMessage.new(connection).send(methods)
      else
        puts "UNKNOWN MESSSAGE!!!! #{req.first}"
      end
    end
  end
end

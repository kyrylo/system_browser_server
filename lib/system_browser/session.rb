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
          if data.instance_of?(String)
            data = self.replace_weird_characters(data)
          end

          action = case @request.action
                   when 'get' then 'add'
                   when 'autoget'then 'autoadd'
                   else 'add'
                   end

          scope = case action
                  when 'add' then @request.scope
                  when 'autoadd' then ''
                  else @request.scope
                  end

          if scope.empty?
            data[:behaviour] = @request.scope
          end

          response = Response.new(
            action: "#{action}:#{@request.resource}:#{scope}",
            data: data)

          @connection.puts(response.to_json)
          return
        end
      end
    end

    protected

    # Temporary hack before we support weird characters for real.
    def replace_weird_characters(data)
      data.force_encoding('ASCII-8BIT').
        encode('UTF-8', undef: :replace, replace: '')
    end
  end
end

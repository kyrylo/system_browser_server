module SystemBrowser
  class RequestProcessor
    def initialize(request:, session:)
      @request = request
      @session = session
      @resources = [
        Resources::Gem,
        Resources::Behaviour,
        Resources::Method,
        Resources::Source
      ]
    end

    def process
      @request.parse

      if @request.sets_client_pid?
        @session.set_client_pid(@request.client_pid)
      else
        resource = self.find_server_resource_for(@request.resource).new
        data = resource.__send__(@request.action, @request.scope, @request.other)
        data = self.replace_weird_characters(data) if data.instance_of?(String)

        action = self.process_action
        scope = self.process_scope(action)

        if scope.empty?
          data[:behaviour] = @request.scope
        end

        action_str = "#{action}:#{@request.resource}:#{scope}"
        response = Response.new(action: action_str, data: data)
        response.set_callback_id(@request.callback_id)

        @session.send(response)
      end
    end

    protected

    ACTIONS = {
      'get' => 'add',
      'autoget' => 'autoadd'
    }.tap { |h| h.default = 'add' }

    def process_action
      ACTIONS[@request.action]
    end

    def process_scope(action)
      case action
      when 'add' then @request.scope
      when 'autoadd' then ''
      else @request.scope
      end
    end

    def find_server_resource_for(req_resource)
      @resources.find { |resource| resource.name == req_resource }
    end

    ##
    # Temporary hack before we support weird characters for real.
    def replace_weird_characters(str)
      ascii_str = str.force_encoding('ASCII-8BIT')
      ascii_str.encode('UTF-8', undef: :replace, replace: '')
    end
  end
end

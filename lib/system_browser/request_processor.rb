module SystemBrowser
  class RequestProcessor
    ACTIONS = {
      'get' => 'add',
      'autoget' => 'autoadd'
    }.tap { |h| h.default = 'add' }

    def initialize(request:, session:)
      @request = request
      @session = session
      @services = [
        Services::GemService,
        Services::BehaviourService,
        Services::MethodService,
        Services::SourceService
      ]
    end

    def process
      @request.parse

      if @request.sets_client_pid?
        @session.set_client_pid(@request.client_pid)
      else
        self.process_services
      end
    end

    protected

    def process_services
      service = self.find_service_for(@request.resource).new()

      data = service.__send__(@request.action, @request.scope, @request.other)
      data = self.replace_weird_characters(data) if data.instance_of?(String)

      action = self.process_action
      scope = self.process_scope(action)

      data[:behaviour] = @request.scope if scope.empty?

      action_str = "#{action}:#{@request.resource}:#{scope}"
      response = Response.new(action: action_str, data: data)
      response.set_callback_id(@request.callback_id)

      @session.send(response)
    end

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

    def find_service_for(req_resource)
      @services.find { |resource| resource.name == req_resource }
    end

    ##
    # Temporary hack before we support weird characters for real.
    def replace_weird_characters(str)
      ascii_str = str.force_encoding('ASCII-8BIT')
      ascii_str.encode('UTF-8', undef: :replace, replace: '')
    end
  end
end

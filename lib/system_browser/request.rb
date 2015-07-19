module SystemBrowser
  class Request
    attr_reader :action, :resource, :scope, :other, :callback_id

    def initialize(json)
      @req = self.get_data(json)
      @data = @req['system_browser_server']

      @action = nil
      @resource = nil
      @scope = nil
      @other = nil
    end

    def parse
      @callback_id = @req['callbackId']

      @action = @data['action']
      @resource = @data['resource']
      @scope = @data['scope']

      @other = @data['other']
    end

    def sets_client_pid?
      @action == Client::PID_COMMAND
    end

    def client_pid
      @resource
    end

    protected

    def get_data(json)
      JSON.parse(json)
    end
  end
end

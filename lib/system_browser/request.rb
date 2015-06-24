module SystemBrowser
  class AbstractRequest
    attr_reader :action, :resource, :scope

    def initialize(json)
      @data = self.get_data(json)

      @action = nil
      @resource = nil
      @scope = nil
    end

    def process
      @action = @data['action']
      @resource = @data['resource']
      @scope = @data['scope']
    end

    def empty?
      @empty
    end

    protected

    def get_data(json)
      JSON.parse(json)['system_browser_server']
    end
  end

  class Request < AbstractRequest
  end
end

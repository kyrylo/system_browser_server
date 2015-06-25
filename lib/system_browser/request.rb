module SystemBrowser
  class Request
    attr_reader :action, :resource, :scope, :other

    def initialize(json)
      @data = self.get_data(json)

      @action = nil
      @resource = nil
      @scope = nil
      @other = nil
    end

    def process
      @action = @data['action']
      @resource = @data['resource']
      @scope = @data['scope']
      @other = @data['other']
    end

    def empty?
      @empty
    end

    protected

    def get_data(json)
      JSON.parse(json)['system_browser_server']
    end
  end
end

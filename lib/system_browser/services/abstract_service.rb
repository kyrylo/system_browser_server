module SystemBrowser
  module Services
    class AbstractService
      def self.service_name
        self.name.split('::').last.split('Service').first.downcase
      end

      def initialize(data:, other: nil)
        @sn = SystemNavigation.default
        @data = data
        @other = other
      end
    end
  end
end

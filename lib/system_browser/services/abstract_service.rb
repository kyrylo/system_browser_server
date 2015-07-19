module SystemBrowser
  module Services
    class AbstractService
      def initialize(data:, other: nil)
        @sn = SystemNavigation.default
        @data = data
        @other = other
      end

      def name
        require 'pry'
        binding.pry
      end
    end
  end
end

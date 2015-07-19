module SystemBrowser
  module Services
    class AbstractService
      def initialize
        @sn = SystemNavigation.default
      end

      def name
        require 'pry'
        binding.pry
      end
    end
  end
end

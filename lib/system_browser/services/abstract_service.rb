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

      protected

      def all_gems
        Gem.loaded_specs
      end

      def find_gem(gem_name)
        self.all_gems[gem_name]
      end
    end
  end
end

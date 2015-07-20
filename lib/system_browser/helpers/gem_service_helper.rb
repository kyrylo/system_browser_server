module SystemBrowser
  module Helpers
    module GemServiceHelper
      def all_gems
        Gem.loaded_specs
      end

      def find_gem(gem_name)
        self.all_gems[gem_name]
      end
    end
  end
end

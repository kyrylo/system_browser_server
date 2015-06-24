module SystemBrowser
  module Resources
    class Behaviour
      def self.name
        'behaviour'
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(gem)
        if Resources::Gem::CORE == (gem)
          CoreClasses.as_set.map(&:name)
        else
          @sn.all_classes_and_modules_in_gem_named(gem).map(&:name)
        end

      end
    end
  end
end

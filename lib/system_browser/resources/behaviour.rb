module SystemBrowser
  module Resources
    class Behaviour
      def self.name
        'behaviour'
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(gem, other_data = nil)
        data = if Resources::Gem::CORE == (gem)
          CoreClasses.as_set
        else
          @sn.all_classes_and_modules_in_gem_named(gem)
        end

        data.map do |behaviour|
          {name: (behaviour.name ? behaviour.name : behaviour.inspect),
           isModule: behaviour.instance_of?(Module),
           isException: behaviour.ancestors.include?(Exception)}
        end
      end
    end
  end
end

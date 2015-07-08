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
        data = case gem
               when Resources::Gem::CORE
                 CoreClasses.as_set
               when Resources::Gem::STDLIB
                 self.stdlib_behaviours
               else
                 @sn.all_classes_and_modules_in_gem_named(gem)
               end

        data.map do |behaviour|
          is_module = behaviour.instance_of?(Module)

          superclass = unless is_module
                         behaviour.superclass
                       end

          {name: (behaviour.name ? behaviour.name : behaviour.inspect),
           isModule: is_module,
           isException: behaviour.ancestors.include?(Exception),
           superclass: superclass}
        end
      end

      def autoget(behaviour, other_data = nil)
        behaviour_obj = SystemBrowser::Behaviour.from_str(behaviour)

        if CoreClasses.as_set.find { |c| c == behaviour_obj }
          {gem: Resources::Gem::CORE}
        elsif self.stdlib_behaviours.find { |c| c == behaviour_obj }
          {gem: Resources::Gem::STDLIB}
        else
          gem = ::Gem.loaded_specs.keys.find do |gem_name|
            behaviours = @sn.all_classes_and_modules_in_gem_named(gem_name)
            behaviours.include?(behaviour_obj)
          end

          {gem: gem}
        end
      end

      protected

      def stdlib_behaviours
        CoreClasses::Stdlib.as_set.map do |behaviour|
          begin
            eval(behaviour)
          rescue
          end
        end.compact
      end
    end
  end
end

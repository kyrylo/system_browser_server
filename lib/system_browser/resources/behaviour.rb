module SystemBrowser
  module Resources
    class Behaviour
      def self.name
        'behaviour'
      end

      def self.stdlib_behaviours
        CoreClasses::Stdlib.as_set.map do |behaviour|
          begin
            eval(behaviour)
          rescue
          end
        end.compact
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(gem, other_data = nil)
        data = case gem
               when Resources::Gem::CORE
                 CoreClasses.as_set
               when Resources::Gem::STDLIB
                 self.class.stdlib_behaviours
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

      def autoget(behaviour, gem_name = nil)
        behaviour_obj = SystemBrowser::Behaviour.from_str(behaviour)

        if CoreClasses.as_set.find { |c| c == behaviour_obj }
          {gem: Resources::Gem::CORE}
        elsif self.class.stdlib_behaviours.find { |c| c == behaviour_obj }
          {gem: Resources::Gem::STDLIB}
        else
          behaviours = @sn.all_classes_and_modules_in_gem_named(gem_name)
          gem = if behaviours.include?(behaviour_obj)
                  gem_name
                else
                  ::Gem.loaded_specs.keys.find do |g|
                    behaviours = @sn.all_classes_and_modules_in_gem_named(g)
                    behaviours.include?(behaviour_obj)
                  end
                end

          {gem: gem}
        end
      end
    end
  end
end

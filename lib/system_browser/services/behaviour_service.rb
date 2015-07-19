module SystemBrowser
  module Services
    class BehaviourService < AbstractService
      CACHED_BEHAVIOURS = {}

      def self.stdlib_behaviours
        CoreClasses::Stdlib.as_set.map do |behaviour|
          begin
            eval(behaviour)
          rescue
          end
        end.compact
      end

      def self.all_from(gem)
        if CACHED_BEHAVIOURS.has_key?(gem)
          CACHED_BEHAVIOURS[gem]
        else
          CACHED_BEHAVIOURS[gem] = SystemNavigation.new.all_classes_and_modules_in_gem_named(gem)
        end
      end

      def get
         self.behaviours.map do |behaviour|
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

      def autoget
        behaviour = SystemBrowser::Behaviour.from_str(@data)

        if CoreClasses.as_set.find { |c| c == behaviour }
          {gem: GemService::CORE_LABEL}
        elsif self.class.stdlib_behaviours.find { |c| c == behaviour }
          {gem: GemService::STDLIB_LABEL}
        else
          behaviours = @sn.all_classes_and_modules_in_gem_named(@other)
          gem = if behaviours.include?(behaviour)
                  @other
                else
                  Gem.loaded_specs.keys.find do |g|
                    behaviours = @sn.all_classes_and_modules_in_gem_named(g)
                    behaviours.include?(behaviour)
                  end
                end

          {gem: gem}
        end
      end

      protected

      def behaviours
        case @data
        when GemService::CORE_LABEL
          CoreClasses.as_set
        when GemService::STDLIB_LABEL
          self.class.stdlib_behaviours
        else
          self.class.all_from(@data)
        end
      end
    end
  end
end

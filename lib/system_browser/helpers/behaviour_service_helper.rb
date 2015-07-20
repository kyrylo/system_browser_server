module SystemBrowser
  module Helpers
    module BehaviourServiceHelper
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

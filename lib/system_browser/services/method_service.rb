module SystemBrowser
  module Services
    class MethodService
      def self.name
        'method'
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(behaviour, other_data = nil)
        behaviour_obj = SystemBrowser::Behaviour.from_str(behaviour)
        method_hash = @sn.all_methods_in_behavior(behaviour_obj)
        method_names_hash(method_hash)
      end

      protected

      def method_names_hash(method_hash)
        new_h = {}

        method_hash.keys.each do |key|
          new_val = method_hash[key].map do |k, values|
            {
              k => values.map do |m|
               {name: m.name.to_s, c_method: m.source_location.nil? }
              end
            }
          end
          new_h[key] = new_val.first.merge(new_val.last)
        end

        new_h
      end
    end
  end
end

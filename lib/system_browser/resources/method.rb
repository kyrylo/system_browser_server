module SystemBrowser
  module Resources
    class Method
      def self.name
        'method'
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(behaviour, other_data = nil)
        method_hash = @sn.all_methods_in_behavior(eval(behaviour))
        method_names_hash(method_hash)
      end

      protected

      def method_names_hash(method_hash)
        new_h = {}

        method_hash.keys.each do |key|
          new_val = method_hash[key].map do |k, values|
            {k => values.map { |n| n.name.to_s}}
          end

          new_h[key] = new_val.first.merge(new_val.last)
        end

        new_h
      end
    end
  end
end

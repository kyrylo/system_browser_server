module SystemBrowser
  module Resources
    class Source
      def self.name
        'source'
      end

      def initialize
        @sn = SystemNavigation.default
      end

      def get(*args)
        hash = args.last
        owner = eval(hash['owner'])
        method = hash['method']['name']

        if method.start_with?('#')
          unbound_method = owner.instance_method(method[1..-1].to_sym)
          FastMethodSource.comment_and_source_for(unbound_method)
        end
      end
    end
  end
end

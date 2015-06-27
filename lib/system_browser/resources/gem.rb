module SystemBrowser
  module Resources
    class Gem
      CORE = 'Ruby Core'
      STDLIB = 'Ruby Stdlib'
      DEFAULT_GEMS = [CORE, STDLIB]

      def self.name
        'gem'
      end

      def get(*args)
        gems = ::Gem.loaded_specs.map do |gem|
          {name: gem.first}
        end

        [*DEFAULT_GEMS, *gems]
      end
    end
  end
end

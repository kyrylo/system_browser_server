module SystemBrowser
  module Resources
    class Gem
      CORE = 'Ruby Core'
      STDLIB = 'Ruby Stdlib'
      DEFAULT_GEMS = [{name: CORE}, {name: STDLIB}]

      def self.name
        'gem'
      end

      def get(*args)
        gems = ::Gem.loaded_specs.map do |gem|
          {name: gem.first}
        end

        [*DEFAULT_GEMS, *gems]
      end

      def open(*args)
        gem_name = args.first
        editor = [ENV['VISUAL'], ENV['EDITOR']].find{|e| !e.nil? && !e.empty? }
        path = ::Gem.loaded_specs[gem_name].full_gem_path

        command = [*Shellwords.split(editor), path]

        system(*command)

        :ok
      end
    end
  end
end

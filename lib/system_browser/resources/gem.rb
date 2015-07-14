# coding: utf-8
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

      def description(*args)
        gem_name = args.first
        gem = ::Gem.loaded_specs[gem_name]

        case gem_name
        when CORE
          desc = <<DESC
Ruby Core-#{RUBY_VERSION}
===
The Ruby Standard Library is a vast collection of classes and modules that you can require in your code for additional features.
DESC

          {
            description: desc,
            behaviours: self.count_behaviours(CoreClasses.as_set),
            development_deps: [],
            runtime_deps: [],
          }
        when STDLIB
          {
            description: "# Ruby Standard Library-#{RUBY_VERSION}",
            behaviours: self.count_behaviours(Resources::Behaviour.stdlib_behaviours),
            development_deps: [],
            runtime_deps: []
          }
        else
          gemdata = Gem2Markdown.convert(gem)
          behs = Resources::Behaviour.new.get(gem.name).map { |p| eval(p[:name]) }
          gemdata[:behaviours] = count_behaviours(behs)
          gemdata
        end
      end

      def open(*args)
        gem_name = args.first
        editor = [ENV['VISUAL'], ENV['EDITOR']].find{|e| !e.nil? && !e.empty? }
        path = ::Gem.loaded_specs[gem_name].full_gem_path

        command = [*Shellwords.split(editor), path]

        system(*command)

        :ok
      end

      protected

      def count_behaviours(collection)
        behaviours = {}

        grouped = collection.group_by(&:class)

        exceptions = (grouped[Class] || []).group_by do |beh|
          beh.ancestors.include?(Exception)
        end

        behaviours['modules'] = (grouped[Module] || []).count
        behaviours['classes'] = (exceptions[false] || []).count
        behaviours['exceptions'] = (exceptions[true] || []).count

        behaviours
      end
    end
  end
end

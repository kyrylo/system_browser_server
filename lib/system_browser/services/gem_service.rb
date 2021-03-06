module SystemBrowser
  module Services
    class GemService < AbstractService
      CORE_LABEL = 'Ruby Core'
      STDLIB_LABEL = 'Ruby Stdlib'
      DEFAULT_GEMS = [{name: CORE_LABEL}, {name: STDLIB_LABEL}]

      def get
        gems = self.all_gems.map { |gem| {name: gem.first} }
        [*DEFAULT_GEMS, *gems]
      end

      def description(*args)
        gem = self.find_gem(@data)

        case @data
        when CORE_LABEL
          desc = <<DESC
Ruby Core-#{RUBY_VERSION}
===
The Ruby Core defines common Ruby behaviours available to every program.
DESC

          {
            description: desc,
            behaviours: self.count_behaviours(CoreClasses.as_set),
            development_deps: [],
            runtime_deps: [],
          }
        when STDLIB_LABEL
          desc = <<DESC
Ruby Standard Library-#{RUBY_VERSION}
===
The Ruby Standard Library is a vast collection of classes and modules that you can require in your code for additional features. System Browser shows only those behaviours that were required by this Ruby process.
DESC
          {
            description: desc,
            behaviours: self.count_behaviours(self.stdlib_behaviours),
            development_deps: [],
            runtime_deps: []
          }
        else
          gemdata = Gem2Markdown.convert(gem)
          behs = BehaviourService.all_from(gem.name)
          gemdata[:behaviours] = count_behaviours(behs)
          gemdata
        end
      end

      def open
        editor = [ENV['VISUAL'], ENV['EDITOR']].find{|e| !e.nil? && !e.empty? }
        path = self.find_gem(@data).full_gem_path

        command = [*Shellwords.split(editor), path]

        system(*command)

        :ok
      end

      protected

      include SystemBrowser::Helpers::GemServiceHelper
      include SystemBrowser::Helpers::BehaviourServiceHelper

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

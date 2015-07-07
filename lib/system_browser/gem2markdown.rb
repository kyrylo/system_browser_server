module SystemBrowser
  class Gem2Markdown
    def self.convert(gem)
      self.new(gem).convert
    end

    def initialize(gem)
      @gem = gem
    end

    def convert
      document = ''

      [header,
       summary,
       homepage,
       license,
       author,
       email,
       newline,
       description,
       runtime_deps,
       newline,
       development_deps
      ].each do |doc|
        document += (doc || '')
       end

      document + newline
    end

    private

    def header
      "#{@gem.full_name}\n==" + newline
    end

    def summary
      if @gem.summary
        @gem.summary + newline
      end
    end

    def homepage
      if @gem.homepage
        li("homepage: #{@gem.homepage}") + newline
      end
    end

    def license
      if @gem.licenses.any?
        licenses = @gem.licenses.join(', ')
        li("license: #{licenses}") + newline
      end
    end

    def author
      if @gem.authors.any?
        authors = @gem.authors.join(', ')
        li("by #{authors}") + newline
      end
    end

    def description
      if @gem.description
        @gem.description + newline
      end
    end

    def email
      if @gem.email
        li_h = 'email: '
        email = @gem.email
        item = nil

        item = case email
               when String
                 li(li_h + email)
               when Array
                 li(li_h + email.join(', '))
               else
                 fail RuntimeError, 'wrong email format'
               end

        item + newline
      end

    end

    def runtime_deps
      if @gem.runtime_dependencies.any?
        title = '## Runtime dependencies'
        deps = @gem.runtime_dependencies.map do |(name, _ver, _type)|
          li(name.to_s)
        end

        title + newline + deps.join("\n") + newline
      end
    end

    def development_deps
      if @gem.development_dependencies.any?
        title = '## Development dependencies'
        deps = @gem.development_dependencies.map do |(name, _ver, _type)|
          li(name.to_s)
        end

        title + newline + deps.join("\n") + newline
      end
    end


    def li(item)
      '* ' + item
    end

    def newline(n = 1)
      "\n" * n
    end
  end
end

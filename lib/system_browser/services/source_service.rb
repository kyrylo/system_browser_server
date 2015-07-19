module SystemBrowser
  module Services
    class SourceService < AbstractService
      def get
        method = @other['method']['displayName']
        owner = SystemBrowser::Behaviour.from_str(@other['owner'])

        source = if method.start_with?('#')
                   unbound_method = owner.instance_method(method[1..-1].to_sym)
                   FastMethodSource.comment_and_source_for(unbound_method)
                 elsif method.start_with?('.')
                   unbound_method = owner.singleton_class.instance_method(method[1..-1].to_sym)
                   FastMethodSource.comment_and_source_for(unbound_method)
                 end

        CodeRay.scan(self.unindent(source), :ruby).div
      end

      protected

      # Remove any common leading whitespace from every line in `text`.
      #
      # This can be used to make a HEREDOC line up with the left margin, without
      # sacrificing the indentation level of the source code.
      #
      # e.g.
      #   opt.banner unindent <<-USAGE
      #     Lorem ipsum dolor sit amet, consectetur adipisicing elit,
      #     sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
      #       "Ut enim ad minim veniam."
      #   USAGE
      #
      # Heavily based on textwrap.dedent from Python, which is:
      #   Copyright (C) 1999-2001 Gregory P. Ward.
      #   Copyright (C) 2002, 2003 Python Software Foundation.
      #   Written by Greg Ward <gward@python.net>
      #
      #   Licensed under <http://docs.python.org/license.html>
      #   From <http://hg.python.org/cpython/file/6b9f0a6efaeb/Lib/textwrap.py>
      #
      # @param [String] text The text from which to remove indentation
      # @return [String] The text with indentation stripped.
      def unindent(text, left_padding = 0)
        # Empty blank lines
        text = text.sub(/^[ \t]+$/, '')

        # Find the longest common whitespace to all indented lines
        # Ignore lines containing just -- or ++ as these seem to be used by
        # comment authors as delimeters.
        margin = text.scan(/^[ \t]*(?!--\n|\+\+\n)(?=[^ \t\n])/).inject do |current_margin, next_indent|
          if next_indent.start_with?(current_margin)
            current_margin
          elsif current_margin.start_with?(next_indent)
            next_indent
          else
            ""
          end
        end

        text.gsub(/^#{margin}/, ' ' * left_padding)
      end
    end
  end
end

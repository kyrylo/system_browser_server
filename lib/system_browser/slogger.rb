module SystemBrowser
  module SLogger
    class << self
      @@logger = ::Logger.new(STDOUT)

      [:debug, :error, :info].each do |m|
        define_method(m) do |*args, &block|
          if $DEBUG_SB
            # Avoid the 'log writing failed due to trap' message in trap contexts.
            Thread.new { @@logger.__send__(m, *args, &block) }.join
          end
        end
      end

      def log_error(error)
        SLogger.error(error.class) do
          [error.to_s, error.backtrace].join("\n")
        end
      end
    end
  end
end

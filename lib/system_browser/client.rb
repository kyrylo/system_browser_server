module SystemBrowser
  class Client
    ##
    # The command that the client sends to the server at the session
    # initialisation.
    PID_COMMAND = 'set-window-pid'

    ##
    # The name of the executable of the client application.
    CLIENT_EXECUTABLE = 'system_browser'

    ##
    # @return [SystemBrowser::Session]
    attr_writer :session

    def initialize
      @init_pid = nil

      self.register_sigint_hook
    end

    ##
    # Spawns a new process in the same process group with the client
    # application.
    #
    # @note +@init_pid+ and +@window_pid+ are two different processes. The
    # client uses +@init_id+ to bootstrap itself and +@window_pid+ is the
    # process that can be used to send signals to the client.
    #
    # @return [Integer] the process ID of the client application
    def start
      @init_pid = spawn(CLIENT_EXECUTABLE)
      Process.wait(@init_pid)

      @init_pid
    end

    ##
    # @return [Integer] the process ID of the client process (window).
    def window_pid=(window_pid)
      SLogger.debug("[client] setting window pid (#{window_pid})")
      @window_pid = window_pid
    end

    protected

    def register_sigint_hook
      Signal.trap(:INT) do
        # Avoid the 'log writing failed due to trap' message.
        Thread.new do
          SLogger.debug("Interrupting client (#{@window_pid})...")
        end.join

        Process.kill(:INT, @window_pid)
      end
    end
  end
end

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

    ClientNotFoundError = Class.new(RuntimeError)

    def initialize
      @init_pid = nil
    end

    ##
    # Spawns a new process in a new process group. I really wanted to find the
    # way to spawn the process in the same group. However, when I do that, I
    # cannot send any signals to the window anymore (the app crashes, because
    # the ruby process exits).
    #
    # @note +@init_pid+ and +@window_pid+ are two different processes. The
    # client uses +@init_id+ to bootstrap itself and +@window_pid+ is the
    # process that can be used to send signals to the client.
    #
    # @return [Integer] the process ID of the client application
    # @raise [RuntimeError]
    def start
      unless system("which #{CLIENT_EXECUTABLE} > /dev/null 2>&1")
        fail ClientNotFoundError, "executable '#{CLIENT_EXECUTABLE}' is not on your $PATH"
      end

      @init_pid = spawn(CLIENT_EXECUTABLE, pgroup: true)
      Process.wait(@init_pid)

      @init_pid
    end

    ##
    # @return [Integer] the process ID of the client process (window).
    def window_pid=(window_pid)
      SLogger.debug("[client] setting window pid (#{window_pid})")
      @window_pid = window_pid
    end

    ##
    # Destroys the window by sending the SIGINT signal (the window has its own
    # handlers to destroy itself, so it's not our job). Does not wait for
    # anything.
    # @return [void]
    def close
      SLogger.debug("[client] interrupting window (#{@window_pid})...")

      Process.kill(:INT, @window_pid)
    end
  end
end

module SystemBrowser
  ##
  # This class glues {SystemBrowser::Server} and {SystemBrowser::Client}
  # providing the support for interaction between them.
  class Session
    @@running_session = false

    ##
    # Initialises a new session.
    def self.init
      if @@running_session
        SLogger.debug("can't init a new session! Kill the old one first")
        return
      else
        @@running_session = true
      end

      self.new(Server.new, Client.new).init
    end

    # @return [TCPSocket] the connection between the server and the client
    attr_reader :connection

    def initialize(server, client)
      @server = server
      @client = client
      [@server, @client].each { |o| o.session = self }

      @previous_sigint_callback = nil

      self.register_sigint_hook
    end

    ##
    # Runs {SystemBrowser::Server} in background. Invokes {SystemBrowser::Client}
    # and suspends the calling thread for the duration of the client.
    # @return [void]
    def init
      Thread.new { @server.start }
      Thread.new { @client.start }.join

      true
    end

    def destroy
      self.restore_previous_sigint

      @client.close
      @server.shutdown

      SLogger.debug('[SESSION] the session was destroyed')
    end

    ##
    # Sets the client's window pid (real pid).
    def set_client_pid(pid)
      @client.window_pid = pid
    end

    ##
    # Sends a response to the client.
    #
    # @param response [SystemBrowser::Response] the data to be sent to the client
    # @return [void]
    def send(response)
      self.connection.puts(response.to_json)
    end

    ##
    # @param connection [TCPSocket] the connection between the server and the
    # client
    # @return [void]
    def connection=(connection)
      @connection = connection
      self.initialize_connection
    end

    protected

    ##
    # This method bootstraps the connection between the server and the client.
    # @return [void]
    def initialize_connection
      self.send(Response.new(action: 'init'))
    end

    def restore_previous_sigint
      Signal.trap(:INT, @previous_sigint_callback)
    end

    def register_sigint_hook
      @previous_sigint_callback = Signal.trap(:INT, '')

      Signal.trap(:INT) do
        SLogger.debug('[SESSION] received Ctrl-C, killing myself softly')

        self.destroy

        if @previous_sigint_callback.instance_of?(Proc)
          self.restore_previous_sigint
          @previous_sigint_callback.call
        end
      end
    end
  end
end

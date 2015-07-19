module SystemBrowser
  ##
  # This class glues {SystemBrowser::Server} and {SystemBrowser::Client}
  # providing the support for interaction between them.
  class Session
    ##
    # Initialises a new session.
    def self.init
      self.new(Server.new, Client.new).init
    end

    # @return [TCPSocket] the connection between the server and the client
    attr_reader :connection

    def initialize(server, client)
      @server = server
      @client = client
      [@server, @client].each { |o| o.session = self }
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
  end
end

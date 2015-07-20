module SystemBrowser
  class Server
    ##
    # @return [SystemBrowser::Session]
    attr_accessor :session

    def initialize(port = 9696)
      self.create_tcpserver(port)
    end

    ##
    # Starts the TCP server.
    #
    # @note This method blocks the thread.
    def start
      Socket.accept_loop(@tcpserver) do |connection|
        SLogger.debug("[server] accepted a new connection (#{connection})")

        self.session.connection = connection
        self.handle_connection(connection)
      end
    rescue IOError
      Thread.exit
    end

    protected

    ##
    # Creates a new TCP server and tries to find a free port.
    # @return [void]
    def create_tcpserver(port)
      @tcpserver = TCPServer.new(port)
    rescue Errno::EADDRINUSE
      SLogger.debug("[server] port #{port} is occupied. Trying port #{port + 1}")

      port += 1
      retry
    end

    ##
    # Handles incoming connections.
    #
    # @param connection [TCPSocket]
    # @return [void]
    def handle_connection(connection)
      loop do
        unless readval = connection.gets
          SLogger.debug("[server] connection #{connection} interrupted. Shutting down...")

          @tcpserver.close
          break
        end

        SLogger.debug("[server] received a request")

        self.process_request(Request.new(readval))
      end
    end

    ##
    # @param request [SystemBrowser::Request]
    # @return [void]
    def process_request(request)
      RequestProcessor.new(request: request, session: self.session).process
    rescue => e
      SLogger.log_error(e)
    end
  end
end

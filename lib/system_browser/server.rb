module SystemBrowser
  class Server
    def self.start
      self.new.start
    end

    def initialize(port = 9696)
      @server = TCPServer.new(port)
      @session = Session.new
    end

    def start
      Socket.accept_loop(@server) do |connection|
        LOGGER.debug('Accepted a new connection') if $DEBUG_SB

        @session.connection = connection
        LOGGER.debug('Initialized a new session') if $DEBUG_SB

        self.handle_connection(connection)
      end
    end

    protected

    def handle_connection(connection)
      loop do
        request = Request.new(connection.gets)

        LOGGER.debug('Received a request') if $DEBUG_SB

        @session.process_request(request)
        @session.process_response
      end
    end
  end
end

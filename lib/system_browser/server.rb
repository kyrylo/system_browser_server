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
        @session.connection = connection
        SLogger.debug('Accepted a new connection')

        self.handle_connection(connection)
      end
    end

    protected

    def handle_connection(connection)
      loop do
        request = Request.new(connection.gets)

        SLogger.debug("Received a request")

        self.process_request(request)
        self.process_response
      end
    end

    def process_request(request)
      @session.process_request(request)
    rescue => e
      SLogger.error(e.class) { e.to_s }
    end

    def process_response
      @session.process_response
    rescue => e
      SLogger.error(e.class) { e.to_s }
    end
  end
end

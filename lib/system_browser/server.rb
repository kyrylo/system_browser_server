module SystemBrowser
  class Server
    @@running = false

    def self.start(port = 9696)
      SLogger.debug("Socket server started on port #{port}")
      self.new(port).start
    end

    def initialize(port)
      return if @@running

      begin
        @server = TCPServer.new(port)
      rescue Errno::EADDRINUSE
        port += 1
        retry
      end
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
        readval = connection.gets
        if readval.nil?
          SLogger.debug('Connection disconnected')
          @server.close
          break
        end

        request = Request.new(readval)

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

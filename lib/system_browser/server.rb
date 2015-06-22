module SystemBrowser
  class Server
    def self.start
      self.new.start
    end

    def initialize(port = 9696)
      @server = TCPServer.new(port)
    end

    def start
      Socket.accept_loop(@server) do |connection|
        initialize_connection(connection)
        handle(connection)
      end
    end

    def initialize_connection(connection)
      send_core(connection)
      send_gem_list(connection)
    end

    def send_core(connection)
      #classes = CoreClasses.as_set.map(&:name)
      Message::AddGemMessage.new(connection).send(['Ruby Core'])
    end

    def send_gem_list(connection)
      gems = Gem.loaded_specs.keys
      Message::AddGemMessage.new(connection).send(gems)
    end

    def handle(connection)
      loop do
        request = connection.gets
        process(request, connection)
      end
    end

    def process(request, connection)
      req = request.chop.split
      data = req[1..-1].join

      case req.first
      when 'GET_BEHAVIORS'
        if data == 'RubyCore'
          behaviors = CoreClasses.as_set.map(&:name)
          Message::AddBehaviorMessage.new(connection).send(behaviors)
        else
          sn = SystemNavigation.default
          behaviors = sn.all_classes_and_modules_in_gem_named(req.last).map(&:name)
          Message::AddBehaviorMessage.new(connection).send(behaviors)
        end
      when 'GET_METHODS'
        sn = SystemNavigation.default
        method_hash = sn.all_methods_in_behavior(eval(data))
        methods = method_hash.as_array.map(&:name)
        Message::AddMethodMessage.new(connection).send(methods)
      end
    end
  end
end

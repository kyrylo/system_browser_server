module SystemBrowser
  class Message
    class AddMethodMessage < Message
      def initialize(*args)
        super(*args)
        @command = 'ADD_METHOD'
      end
    end
  end
end

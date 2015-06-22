module SystemBrowser
  class Message
    class AddBehaviorMessage < Message
      def initialize(*args)
        super(*args)
        @command = 'ADD_BEHAVIOR'
      end
    end
  end
end

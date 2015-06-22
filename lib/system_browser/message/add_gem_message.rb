module SystemBrowser
  class Message
    class AddGemMessage < Message
      def initialize(*args)
        super(*args)
        @command = 'ADD_GEM'
      end
    end
  end
end

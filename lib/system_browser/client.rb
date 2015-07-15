module SystemBrowser
  class Client
    def self.start
      self.new.start
    end

    def initialize
      @client = 'system_browser'
    end

    def start
      pid = spawn(@client)
      Process.wait(pid)
      pid
    rescue Errno::ENOENT
      warn %|ERROR: Can't find the "system_browser" executable in your PATH|
    end
  end
end

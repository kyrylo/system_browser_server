module SystemBrowser
  module Client
    EXECUTABLE = 'system_browser'

    def self.start
      pid = spawn(EXECUTABLE)
      Process.wait(pid)
      pid
    end
  end
end

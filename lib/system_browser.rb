require 'socket'
require 'json'
require 'logger'
require 'shellwords'

require 'system_navigation'
require 'core_classes'

require_relative 'system_browser/server'
require_relative 'system_browser/session'
require_relative 'system_browser/request'
require_relative 'system_browser/response'
require_relative 'system_browser/slogger'
require_relative 'system_browser/resources/gem'
require_relative 'system_browser/resources/behaviour'
require_relative 'system_browser/resources/method'
require_relative 'system_browser/resources/source'

module SystemBrowser
  def self.start
    if $DEBUG_SB
      Thread.abort_on_exception = true
    end

    th = Thread.new do
      Server.start
    end

    SLogger.debug('Started the Socket server')

    th
  end
end

require 'socket'
require 'json'
require 'logger'

require 'system_navigation'
require 'core_classes'

require_relative 'system_browser/server'
require_relative 'system_browser/session'
require_relative 'system_browser/request'
require_relative 'system_browser/response'
require_relative 'system_browser/resources/gem'
require_relative 'system_browser/resources/behaviour'

module SystemBrowser
  LOGGER = Logger.new(STDOUT)

  def self.start
    Thread.abort_on_exception = true

    th = Thread.new do
      Server.start
    end

    LOGGER.debug('Started the Socket server') if $DEBUG_SB

    th
  end
end

require 'socket'
require 'json'
require 'logger'
require 'shellwords'

require 'system_navigation'
require 'core_classes'
require 'coderay'

require_relative 'system_browser/server'
require_relative 'system_browser/client'
require_relative 'system_browser/session'
require_relative 'system_browser/request'
require_relative 'system_browser/request_processor'
require_relative 'system_browser/response'
require_relative 'system_browser/slogger'
require_relative 'system_browser/behaviour'
require_relative 'system_browser/gem2markdown'
require_relative 'system_browser/resources/gem'
require_relative 'system_browser/resources/behaviour'
require_relative 'system_browser/resources/method'
require_relative 'system_browser/resources/source'

module SystemBrowser
  ##
  # Starts the system browser.
  #
  # @param debug [Boolean] If true, prints debugging information
  # @param nonblock [Boolean] If true, then creates a new thread. Otherwise
  #   runs in the current thread
  # @return [Session.init]
  def self.start(debug: false, nonblock: false)
    $DEBUG_SB = debug

    if $DEBUG_SB
      Thread.abort_on_exception = true
    end

    if nonblock
      Thread.new { Session.init }
    else
      Session.init
    end
  end
end

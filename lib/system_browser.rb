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
require_relative 'system_browser/helpers/gem_service_helper'
require_relative 'system_browser/helpers/behaviour_service_helper'
require_relative 'system_browser/services/abstract_service'
require_relative 'system_browser/services/gem_service'
require_relative 'system_browser/services/behaviour_service'
require_relative 'system_browser/services/method_service'
require_relative 'system_browser/services/source_service'

module SystemBrowser
  ##
  # Starts the system browser.
  #
  # @param debug [Boolean] If true, prints debugging information
  # @param nonblock [Boolean] If true, then creates a new thread. Otherwise
  #   runs in the current thread
  # @return [Session.init]
  def self.start(debug: false, block: true)
    $DEBUG_SB = debug

    if $DEBUG_SB
      Thread.abort_on_exception = true
    end

    if block
      Session.init
    else
      Thread.new { Session.init }
    end
  end
end

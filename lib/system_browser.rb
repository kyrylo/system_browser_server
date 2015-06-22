require 'socket'
require 'json'

require 'system_navigation'
require 'core_classes'

require_relative 'system_browser/server'
require_relative 'system_browser/message'
require_relative 'system_browser/message/add_gem_message'
require_relative 'system_browser/message/add_behavior_message'
require_relative 'system_browser/message/add_method_message'

module SystemBrowser
  def self.start
    Server.start
  end
end

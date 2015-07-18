require_relative '../lib/system_browser'

# Enable debugging information for System Browser.
$DEBUG_SB = true

# Start the browser.
# Normally, you don't have to care about the server thread.
# However, if your program terminates quickly, you must join the client_thread.
_server_thread, client_thread = SystemBrowser.start
puts "Joining the client thread"
client_thread.join

puts "BYE"
#require 'pry'; binding.pry

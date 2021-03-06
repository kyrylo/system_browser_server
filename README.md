System Browser
==

* [Repository](https://github.com/kyrylo/system_browser_server/)
* [Client][client]
* [Video demonstration](https://youtu.be/CKDxMBC86zA)

Description
-----------

System Browser is a Ruby gem that serves as a bridge between a Ruby process
and the [System Browser Client][client]. It allows you to browse Ruby
behaviours (classes and modules), its methods and the methods' source code.
_Make sure that you have the client installed_.

Examples
--------

The easiest way to play with System Browser is to start it from a REPL such as
[Pry](http://pryrepl.org/) or [IRB](https://github.com/ruby/ruby/blob/8754f619
d51a67fc4df255c189c8ff744433dd6e/lib/irb.rb).

### Basic example

```ruby
require 'system_browser'

SystemBrowser.start
```

### Nonblocking start

By default `SystemBrowser.start` blocks the current thread. This is useful if you
launch the browser from a small script. If you start the browser inside a
complex framework such as Rails, blocking may be unwanted. In this case start
the browser like this:

```ruby
SystemBrowser.start(block: false)
```

The `block` flag will run the browser in a separate thread and return it (it's
up to you if you want to join it).

### Debugging

If you wish to contribute, you may find the `debug` flag useful. For debugging
purposes invoke the browser like this:

```ruby
SystemBrowser.start(debug: true)
```

For additional information see the `examples/` directory.

Installation
------------

All you need is to install the gem.

    gem install system_browser

Limitations
-----------

Supports *only* CRuby.

* CRuby 2.2.2 and higher

Other Ruby versions were not tested, but in theory Ruby 2.2.x should work fine.

License
-------

The project uses the Zlib License. See LICENCE.txt file for more information.

[client]: https://github.com/kyrylo/system_browser_client/

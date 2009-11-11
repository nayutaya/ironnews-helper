#! ruby -Ku

require "test/unit"
Test::Unit::AutoRunner.run(true, File.dirname(__FILE__), ['--pattern=/_test\.rb\Z/'])

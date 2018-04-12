begin
  require 'minitest'
rescue LoadError
  require 'formatters/minitest/unit'
  MiniTest::Unit.runner = Formatters::MiniTest::Unit.new
end

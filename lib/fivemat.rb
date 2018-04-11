require 'fivemat/elapsed_time'

module Fivemat
  autoload :Cucumber, 'fivemat/cucumber'
  autoload :MiniTest, 'fivemat/minitest/unit'
  autoload :RSpec, 'fivemat/rspec'
  autoload :RSpec3, 'fivemat/rspec3'
  autoload :Spec, 'fivemat/spec'

  # Cucumber 2 detects the formatter API based on initialize arity
  def initialize(runtime, path_or_io, options)
  end

  def rspec3?
    defined?(::RSpec::Core) && ::RSpec::Core::Version::STRING >= '3.0.0'
  end
  module_function :rspec3?

  def self.new(*args)
    case args.size
    when 0 then MiniTest::Unit
    when 1 then
      if rspec3?
        RSpec3
      else
        RSpec
      end
    when 2 then Spec
    when 3
      if ::Cucumber::VERSION >= '3'
        abort "Fivemat does not yet support Cucumber 3"
      end
      Cucumber
    else
      raise ArgumentError
    end.new(*args)
  end
end

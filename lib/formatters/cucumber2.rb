require 'cucumber/formatter/progress'
require_relative 'elapsed_time'

module Formatters
  class Cucumber2 < ::Cucumber::Formatter::Progress
    include ElapsedTime

    def feature_name(_keyword, name)
      @io.print "#{name.sub(/^\s*/, '').split("\n").first} "
      @io.flush
    end
  end
end

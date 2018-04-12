require 'cucumber/formatter/progress'
require_relative 'elapsed_time'

module Formatters
  class Cucumber2 < ::Cucumber::Formatter::Progress
    include ElapsedTime

    def feature_name(_keyword, name)
      @io.print "#{name.sub(/^\s*/, '').split("\n").first} "
      @io.flush
    end

    def before_feature(_feature)
      @exceptions = []
      @start_time = Time.now
    end

    def after_feature(_feature)
      print_elapsed_time @io, @start_time
      @io.puts

      @exceptions.each do |(exception, status)|
        print_exception(exception, status, 2)
      end
    end

    def exception(exception, status)
      @exceptions << [exception, status]
      super if defined?(super)
    end
  end
end

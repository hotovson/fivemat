require_relative 'elapsed_time'

module Fivemat
  class Rspec3
    include ElapsedTime

    ::RSpec::Core::Formatters.register self,
                                       :example_passed,
                                       :example_pending,
                                       :example_failed,
                                       :example_group_started,
                                       :example_group_finished,
                                       :dump_summary,
                                       :seed,
                                       :message

    attr_reader :output, :failed_notifications

    def initialize(output)
      @output = output
      @group_level = 0
      @index_offset = 0
      @failed_notifications = []
    end

    def color
      unless Object.const_defined?('RSpec::Core::Formatters::ConsoleCodes')
        require 'rspec/core/formatters/console_codes'
      end
      ::RSpec::Core::Formatters::ConsoleCodes
    end

    def example_passed(_notification)
      output.print color.wrap('.', :success)
    end

    def example_pending(_notification)
      output.print color.wrap('*', :pending)
    end

    def example_failed(notification)
      @failed_notifications << notification
      output.print color.wrap('F', :failure)
    end

    def example_group_started(event)
      if @group_level.zero?
        output.print "#{event.group.description} "
        @start_time = Time.now
      end

      @group_level += 1
    end

    def example_group_finished(_event)
      @group_level -= 1

      if @group_level.zero?
        print_elapsed_time output, @start_time
        output.puts

        failed_notifications.each_with_index do |failure, index|
          output.puts failure.fully_formatted(@index_offset + index + 1)
        end

        @index_offset += failed_notifications.size
        failed_notifications.clear
      end
    end

    def dump_summary(summary)
      output.puts summary.fully_formatted
    end

    def seed(notification)
      return unless notification.seed_used?
      output.puts notification.fully_formatted
    end

    def message(notification)
      output.puts notification.message
    end
  end
end

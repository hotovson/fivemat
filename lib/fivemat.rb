rspec_version = (::RSpec::Core::Version::STRING if Object.const_defined?('RSpec::Core::Version')) || ''
if rspec_version >= '3'
  require 'formatters/rspec3'
  class Fivemat
    include Formatters::RSpec3
  end
end

cucumber_version = (::Cucumber::VERSION if Object.const_defined?('Cucumber')) || ''
if cucumber_version >= '2' && cucumber_version < '3'
  require 'formatters/cucumber2'
  Object.send(:remove_const, 'Fivemat') if Object.const_defined?('Fivemat')
  Fivemat = Formatters::Cucumber2
end

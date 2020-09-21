require "bundler/setup"
require "yml2h"

# Test case helper methods
module Helpers
  def get_file(name)
    Pathname.new(File.expand_path("../examples/#{name}", __dir__))
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include(Helpers)
end

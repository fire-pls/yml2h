require "bundler/setup"
require "yml2h"

# Test case constants
FOO_TEAM = {
  name: "Foos",
  rank: 1,
  users: [
    {
      name: "Mario Lopez",
      email: "lil@mr.e",
      tos_acceptance: true,
      address: {
        street: "foosgonewild"
      },
      profile: {
        introduction: "foosgonewild.com/shop",
        hobbies: ["stuntin'"]
      },
      meta: {
        created_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
        updated_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
        uuid: "f0000000-f000-f000-f000-f00000000000"
      }
    }
  ],
  budget: {
    amount: 1_000_000,
    meta: {
      created_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
      updated_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
      uuid: "f0000000-f000-f000-f000-f00000000000"
    }
  },
  meta: {
    created_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
    updated_at: DateTime.parse("2019-09-01 00:00:00.000000000 Z"),
    uuid: "f0000000-f000-f000-f000-f00000000000"
  }
}.freeze

# Test case helper classes
class FooClass
  attr_accessor :name, :rank, :users, :budget, :meta
end

# Test case helper methods
module Helpers
  def get_file(name)
    Pathname.new(File.expand_path("../examples/#{name}", __dir__))
  end

  def stub_foo(name: FOO_TEAM[:name], rank: FOO_TEAM[:rank], users: FOO_TEAM[:users], budget: FOO_TEAM[:budget], meta: FOO_TEAM[:meta])
    foo = FooClass.new
    foo.name = name
    foo.rank = rank
    foo.users = users
    foo.budget = budget
    foo.meta = meta

    foo
  end

  def extended_klass
    subject.extend(described_class)
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

require_relative "lib/yml2h/version"
require "date"

Gem::Specification.new do |gemspec|
  gemspec.name = "yml2h"
  gemspec.version = Yml2h::VERSION
  gemspec.required_ruby_version = ">= #{IO.read("./.ruby-version").strip}"
  gemspec.required_rubygems_version = Gem::Requirement.new(">= 2.7.4")

  gemspec.date = Date.today.strftime("%Y-%m-%d")
  gemspec.authors = ["Trevor James"]
  gemspec.email = "trevor@osrs-stat.com"

  gemspec.summary = "Convert Ruby hashes to YAML & vice-versa"

  gemspec.homepage = "https://github.com/fire-pls/yml2h"
  gemspec.license = "MIT"

  # Files to include when publishing gem
  gemspec.files = Dir["LICENSE", "README.md", "examples/**/*", "lib/**/*"]
  gemspec.require_path = "lib"

  # Files which can be executed with bundle exec
  # gemspec.bindir = "bin" # TODO: Add cli tools

  # Dependencies
  # None :)

  # Dev Dependencies
  gemspec.add_development_dependency "amazing_print"
  gemspec.add_development_dependency "pry-byebug"
  gemspec.add_development_dependency "rake"
  gemspec.add_development_dependency "rspec", "~> 3.4"
  gemspec.add_development_dependency "standard"
end

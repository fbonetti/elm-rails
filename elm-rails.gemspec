$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "elm/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "elm-rails"
  s.version     = Elm::Rails::VERSION
  s.authors     = ["Frank Bonetti"]
  s.email       = ["frank.r.bonetti@gmail.com"]
  s.homepage    = "https://github.com/fbonetti/elm-rails"
  s.summary     = "Summary of ElmRails."
  s.description = "Description of ElmRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0"
  s.add_dependency "elm-compiler", "~> 0.2.0"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "rspec-rails", "~> 3.5.0.beta3"
  s.add_development_dependency "capybara", "~> 2.4"
  s.add_development_dependency "appraisal", "~> 2.1"
end

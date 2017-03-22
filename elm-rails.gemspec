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

  s.add_dependency "rails", ">= 4.0"
  s.add_dependency "elm-compiler", "~> 0.3.0"

  s.add_development_dependency "minitest"
end

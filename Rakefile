require "bundler/gem_tasks"
require "bundler/setup"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task "spec:bootstrap" do
  sh "rm -rf spec/dummy"
  sh "bundle exec rails new -f spec/dummy"
  sh "echo '\n\ngem \"elm-rails\", path: \"../..\"' >> spec/dummy/Gemfile"
  sh "cd spec/dummy && bundle && cd -"
end

task :default => ["spec:bootstrap", "spec"]

require "elm-compiler"

module Elm
  module Rails
    class Sprockets
      VERSION = '3'

      def self.instance
        @instance ||= new
      end

      def self.call(input)
        instance.call(input)
      end

      def self.cache_key
        instance.cache_key
      end

      attr_reader :cache_key

      def initialize(options = {})
        @cache_key = [self.class.name, VERSION, options].freeze
      end

      def call(input)
        {
          data: Elm::Compiler.compile(input[:filename], elm_make_path: ::Elm::Rails.elm_make_path),
          dependencies: Set.new(elm_dependencies(input[:filename], input[:load_path]).compact),
        }
      end

      private

      # Add all Elm modules imported in the target file as dependencies, then
      # recursively do the same for each of those dependent modules.
      def elm_dependencies(filename, load_path)
        File.read(filename).each_line.flat_map do |line|
          # e.g. `import Quiz.QuestionStore exposing (..)`
          match = line.match(/^import\s+([^\s]+)/)

          next [] if match.nil?

          # e.g. Quiz.QuestionStore
          module_name = match.captures[0]

          # e.g. Quiz/QuestionStore
          dependency_logical_name = module_name.gsub(".", "/")

          # e.g. ~/NoRedInk/app/assets/javascripts/Quiz/QuestionStore.elm
          dependency_filepath = load_path + "/" + dependency_logical_name + ".elm"

          # If we don't find the dependency in our filesystem, assume it's because
          # it comes in through a third-party package rather than our sources.
          if File.file? dependency_filepath
            dependency_uri = ::Sprockets::URIUtils.build_file_digest_uri(dependency_filepath)
            [dependency_uri] +
              elm_dependencies(dependency_filepath, load_path)
          else
            []
          end
        end
      end
    end
  end
end


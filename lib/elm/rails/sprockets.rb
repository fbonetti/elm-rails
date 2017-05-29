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
        context = input[:environment].context_class.new(input)
        DependencyGraph.new(input[:filename], input[:load_path]).each do |dependency|
          context.depend_on dependency
        end
        debug = ENV['ELM_RAILS_DEBUG'].nil? ? nil : ENV['ELM_RAILS_DEBUG'].downcase
        debug_flag = case debug
                     when nil, 'false', '0'
                       false
                     else
                       true
                     end
        context.metadata.merge(
          data: Elm::Compiler.compile(input[:filename], debug: debug_flag, elm_make_path: Elm::Rails.elm_make_path)
        )
      end

      private

      class DependencyGraph < Struct.new(:filename, :load_path)
        # Add all Elm modules imported in the target file as dependencies, then
        # recursively do the same for each of those dependent modules.
        def each &block
          recurse filename, block
        end

        private

        def recurse filename, block
          File.read(filename).each_line do |line|
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
              block.call dependency_logical_name
              recurse dependency_filepath, block
            end
          end
        end
      end
    end
  end
end


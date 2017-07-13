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
        compiled = Elm::Compiler.compile(input[:filename], {
          debug: debug_flag,
          elm_make_path: Elm::Rails.elm_make_path
        })
        context.metadata.merge data: compiled
      end

      private

      def debug_flag
        case ENV['ELM_RAILS_DEBUG']
        when nil, /^false$/i, '0'
          false
        else
          true
        end
      end

      class DependencyGraph < Struct.new(:filename, :load_path)
        def each &block
          recurse File.read(filename), block
        end

        private

        def recurse source, block
          source.scan(import_regex) do |(module_name)|
            logical_name = module_name.gsub(".", "/")
            filepath = load_path + "/" + logical_name + ".elm"

            # If we don't find the dependency in our filesystem, assume it's because
            # it comes in through a third-party package rather than our sources.
            if File.file?(filepath)
              block.call logical_name
              recurse File.read(filepath), block
            end
          end
        end

        def import_regex
          # `import Quiz.Question exposing (..)`
          /^import\s+([^\s]+)/
        end
      end
    end
  end
end


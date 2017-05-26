require "minitest/autorun"
require "./lib/elm/rails/sprockets"
require "sprockets"

class TestMeme < MiniTest::Test
  def test_nested_dependency_detection
    class << Elm::Rails
      def elm_make_path
        `which elm`.chomp
      end
    end

    context.expect :depend_on, nil do |logical_name|
      logical_name == "Parent"
    end

    context.expect :depend_on, nil do |logical_name|
      logical_name == "Child"
    end

    Elm::Rails::Sprockets.instance.call({
      environment: environment,
      filename: "test/unit/fixtures/Grandparent.elm",
      load_path: "test/unit/fixtures",
    })

    context.verify
  end

  private

  def environment
    env = MiniTest::Mock.new
    env.expect :context_class, context_klass
    env
  end

  def context_klass
    klass = MiniTest::Mock.new
    klass.expect :new, context do |input|
      true
    end
    klass
  end

  def context
    @context ||= begin
      c = MiniTest::Mock.new
      c.expect :metadata, metadata
      c
    end
  end

  def metadata
    metadata = MiniTest::Mock.new
    metadata.expect :merge, nil do |*|
      true
    end
  end
end


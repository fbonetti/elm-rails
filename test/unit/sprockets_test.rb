require "minitest/autorun"
require "./lib/elm/rails/sprockets"
require "sprockets"

class TestElmRailsSprockets < MiniTest::Test
  def test_nested_dependency_detection
    graph = Elm::Rails::Sprockets::DependencyGraph.new(
      "test/unit/fixtures/Grandparent.elm",
      "test/unit/fixtures",
    )
    assert_equal ["Parent", "Child"], graph.map { |dep| dep }
  end
end


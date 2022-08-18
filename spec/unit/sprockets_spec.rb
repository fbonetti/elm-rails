require "elm/rails/sprockets"

describe Elm::Rails::Sprockets::DependencyGraph do
  it "calculates nested dependencies" do
    graph = described_class.new(
      "spec/unit/fixtures/Grandparent.elm",
      "spec/unit/fixtures",
    )
    expect(graph.map.to_a).to eq ["Parent", "Child"]
  end
end


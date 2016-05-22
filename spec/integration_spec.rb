require File.expand_path("../dummy/config/environment", __FILE__)
require "capybara/rspec"

Capybara.app = Rails.application

Rails.application.config.action_dispatch.show_exceptions = false

describe "elm-rails", type: :feature do
  let(:elm_dir_path) { File.expand_path("../dummy/app/assets/elm", __FILE__) }

  before do
    Dir.mkdir elm_dir_path rescue Errno::EEXIST
  end

  before do
    File.write File.join(elm_dir_path, "HelloWorld.js.elm"), <<-ELM
module HelloWorld where
import Html exposing (..)
main = h1 [] [ text \"Hello World!\" ]
ELM
  end

  it "serves the compiled javascript" do
    visit "/assets/HelloWorld.js"
    expect(page.body).to include("Elm.HelloWorld")
    expect(page.body).to include("Hello World!")
  end
end

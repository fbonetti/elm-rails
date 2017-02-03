require "elm/rails/helper"
require "elm/rails/railtie"

module Elm
  module Rails
    mattr_accessor(:elm_make_path) { "elm-make" }
  end
end

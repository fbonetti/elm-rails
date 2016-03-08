require "elm/rails/sprockets"

module Elm
  module Rails
    class Engine < ::Rails::Engine
      initializer "elm-sprockets" do |app|
        app.config.assets.paths << "app/assets/elm"

        app.assets.register_engine ".elm", Elm::Rails::Sprockets
        app.assets.register_mime_type "text/x-elm", ".elm"
      end
    end
  end
end

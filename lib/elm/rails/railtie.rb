require "rails"
require "elm/rails/sprockets"

module Elm
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "elm-rails.setup_view_helpers", group: :all do |app|
        ActiveSupport.on_load(:action_view) do
          include ::Elm::Rails::Helper
        end
      end

      initializer "elm-rails.setup_engine", :group => :all do |app|
        sprockets_env = app.assets || app.config.assets
        sprockets_env.paths.concat Dir[app.root.join("app", "assets", "elm")]

        config.assets.configure do |env|
          env.register_mime_type "text/x-elm", extensions: [".elm"]
          env.register_transformer "text/x-elm", "application/javascript", Elm::Rails::Sprockets
        end
      end
    end
  end
end

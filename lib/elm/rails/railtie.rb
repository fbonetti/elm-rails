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
        if Gem::Version.new(::Sprockets::Rails::VERSION) >= Gem::Version.new("3.0.0")
          config.assets.configure do |env|
            sprockets_env = app.assets || app.config.assets
            sprockets_env.paths.concat Dir[app.root.join("app", "assets", "elm")]

            env.register_transformer "text/x-elm", "application/javascript", Elm::Rails::Sprockets
            env.register_mime_type "text/x-elm", extensions: [".elm"]
          end
        else
          app.config.assets.paths << "app/assets/elm"

          app.assets.register_engine ".elm", Elm::Rails::Sprockets
          app.assets.register_mime_type "text/x-elm", ".elm"
        end
      end
    end
  end
end

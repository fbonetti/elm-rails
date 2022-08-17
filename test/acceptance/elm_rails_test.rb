require "minitest/autorun"

describe "elm-rails" do
  before do
    File.write "/tmp/rails_template.rb", <<-RUBY.strip_heredoc
      gem "elm-rails", path: ".."

      file "elm.json", <<~JSON
        {
            "type": "application",
            "source-directories": [
                "app/assets/elm"
            ],
            "elm-version": "0.19.1",
            "dependencies": {
                "direct": {
                    "elm/browser": "1.0.2",
                    "elm/core": "1.0.5",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.1.3",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.3"
                }
            },
            "test-dependencies": {
                "direct": {},
                "indirect": {}
            }
        }
      JSON

      file "app/assets/elm/Hello.elm", <<-ELM.strip_heredoc
        module Hello exposing (..)
        import Html exposing (text)
        main = text "Hello, World"
      ELM

      file "app/assets/javascripts/application.js", <<-JS.strip_heredoc
        //= require Hello
      JS

      inject_into_file "config/application.rb", after: 'require "action_view/railtie"\n' do
        'require "sprockets/railtie"\n'
      end

      inject_into_file "app/assets/config/manifest.js" do
        '//= link_directory ../javascripts .js\n'
      end
    RUBY

    sh 'rm -rf dummy && rails new dummy\
      --template=/tmp/rails_template.rb\
      --skip-action-mailer\
      --skip-active-record\
      --skip-action-cable\
      --skip-puma\
      --skip-spring\
      --skip-listen\
      --skip-coffee\
      --skip-turbolinks\
      --skip-test\
      --no-skip-asset-pipeline\
      --skip-bootsnap\
      --skip-bundle'
  end

  it "compiles elm files" do
    sh 'cd dummy && bundle exec rake assets:precompile'
    sh 'cat dummy/public/assets/application-*.js | grep "$elm$html$Html$text(\'Hello, World\')"'
    sh '! cat dummy/public/assets/application-*.js | grep "Compiled in DEBUG mode"'
    sh '! cat dummy/public/assets/application-*.js | grep "Compiled in DEV mode"'
  end

  it "respects the ELM_RAILS_DEBUG environment variable" do
    sh 'cd dummy && export ELM_RAILS_DEBUG="true" && bundle exec rake assets:precompile'
    sh 'cat dummy/public/assets/application-*.js | grep "Compiled in DEBUG mode"'
  end

  def sh command
    assert system(command)
  end

  class String
    def strip_heredoc
      min = scan(/^[ \t]*(?=\S)/).min
      indent = min && min.size || 0
      gsub(/^[ \t]{#{indent}}/, '')
    end
  end
end


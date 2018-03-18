require "minitest/autorun"

describe "elm-rails" do
  before do
    File.write "/tmp/rails_template.rb", <<-RUBY.strip_heredoc
      gem "elm-rails", path: ".."

      file "app/assets/elm/Hello.elm", <<-ELM.strip_heredoc
        module Hello exposing (..)
        import Html exposing (text)
        main = text "Hello, World"
      ELM

      file "app/assets/javascripts/application.js", <<-JS.strip_heredoc
        //= require Hello
      JS
    RUBY

    sh 'rm -rf dummy && rails new dummy\
      --template=/tmp/rails_template.rb\
      --skip-action-mailer\
      --skip-active-record\
      --skip-puma\
      --skip-action-cable\
      --skip-spring\
      --skip-listen\
      --skip-coffee\
      --skip-turbolinks\
      --skip-test\
      --skip-javascript\
      --skip-bundle'
  end

  it "compiles elm files" do
    sh 'cd dummy && bundle exec rake assets:precompile'
    sh 'cat dummy/public/assets/application-*.js | grep "_elm_lang\$html\$Html\$text(\'Hello, World\')"'
  end

  it "respects the ELM_RAILS_DEBUG environment variable" do
    sh 'cd dummy && export ELM_RAILS_DEBUG="true" && bundle exec rake assets:precompile'
    sh 'cat dummy/public/assets/application-*.js | grep "_elm_lang$virtual_dom$Native_Debug"'
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


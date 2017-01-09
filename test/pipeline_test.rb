require "minitest/autorun"

class TestAssetPipeline < Minitest::Test
  def test_rails_5_0
    Bundler.with_clean_env do
      # Run rake assets:precompile in the sample Rails 5.0 app and confirm that the output JS includes
      # the compiled Elm
      assert system('(cd test/rails5.0 && bundle exec rake assets:precompile && cat public/assets/application-*.js | grep "_elm_lang\$html\$Html\$text(\'Hello, World!\')")'), "Compiling Elm assets in Rails 5 app failed"
    end
  end
end

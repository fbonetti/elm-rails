require "minitest/autorun"

class TestAssetPipeline < Minitest::Test
  def test_rails_5_0
    Bundler.with_clean_env do
      # Run rake assets:precompile in the sample Rails 5.0 app and confirm that the output JS includes
      # the compiled Elm
      assert system('(cd test/acceptance/rails5.0 && bundle exec rake assets:precompile && cat public/assets/application-*.js | grep "_elm_lang\$html\$Html\$text(\'Hello, World!\')")'), "Compiling Elm assets in Rails 5 app failed"
    end
    Bundler.with_clean_env do
      # Set ELM_RAILS_DEBUG and then run rake assets:precompile in the sample
      # Rails 5.0 app and confirm that the output JS includes the Elm debugger
      assert system('(cd test/acceptance/rails5.0 && export ELM_RAILS_DEBUG="true" && bundle exec rake assets:precompile && cat public/assets/application-*.js | grep "_elm_lang$virtual_dom$Native_Debug")'), "Compiling DEBUG Elm assets in Rails 5 app failed" 
    end
  end

  def test_rails_4_2
    Bundler.with_clean_env do
      # Run rake assets:precompile in the sample Rails 4.2.7.1 app and confirm that the output JS includes
      # the compiled Elm
      assert system('(cd test/acceptance/rails4.2 && bundle exec rake assets:precompile && cat public/assets/application-*.js | grep "_elm_lang\$html\$Html\$text(\'Hello, World!\')")'), "Compiling Elm assets in Rails 4.2 app failed"
    end
    Bundler.with_clean_env do
      # Set ELM_RAILS_DEBUG and then run rake assets:precompile in the sample
      # Rails 4.2.7.1 app and confirm that the output JS includes the Elm debugger
      assert system('(cd test/acceptance/rails4.2 && export ELM_RAILS_DEBUG="true" && bundle exec rake assets:precompile && cat public/assets/application-*.js | grep "_elm_lang$virtual_dom$Native_Debug")'), "Compiling DEBUG Elm assets in Rails 4.2 app failed" 
    end
  end
end

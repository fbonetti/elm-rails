require "minitest/autorun"

describe "elm-rails" do
  before do
    assert system('rm -rf dummy')
    assert system('rails new dummy --template=test/acceptance/rails_template.rb --skip-action-mailer --skip-active-record --skip-puma --skip-action-cable --skip-spring --skip-listen --skip-coffee --skip-turbolinks --skip-test --skip-javascript --skip-bundle')
  end

  it "compiles elm files" do
    assert system('cd dummy && bundle exec rake assets:precompile')
    assert system('cat dummy/public/assets/application-*.js | grep "_elm_lang\$html\$Html\$text(\'Hello, World\')"')
  end

  it "respects the ELM_RAILS_DEBUG environment variable" do
    assert system('cd dummy && export ELM_RAILS_DEBUG="true" && bundle exec rake assets:precompile')
    assert system('cat dummy/public/assets/application-*.js | grep "_elm_lang$virtual_dom$Native_Debug"')
  end
end


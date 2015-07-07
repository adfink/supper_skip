require "codeclimate-test-reporter"

ENV["CODECLIMATE_REPO_TOKEN"]="f3e7316d0c988eb52ddca1d5c3f8ba1c91215cfc2e4f331587ddc816d1218928"

CodeClimate::TestReporter.start


RSpec.configure do |config|

  config.expect_with :rspec do |expectations|

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end

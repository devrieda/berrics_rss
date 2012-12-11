require_relative "test_helper"

describe VERSION do
  it "must be defined" do
    BerricsRss::VERSION.wont_be_nil
  end
end

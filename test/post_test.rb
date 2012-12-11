require_relative "test_helper"

describe Post do
  it "must initialize params" do
    post = Post.new(
      :title  => "UNSANCTIONED EVENT: BATTLE LINES", 
      :url    => "http://theberrics.com/gen-ops/unsanctioned-event-battle-lines.html",
      :body   => "Some details", 
      :date   => "12-11-2012",
      :time   => "06:00 AM")

    post.title.must_equal "Unsanctioned Event: Battle Lines"
    post.body.must_equal  "Some details"
    post.url.must_equal   "http://theberrics.com/gen-ops/unsanctioned-event-battle-lines.html"

    post.created_at.month.must_equal  12
    post.created_at.day.must_equal    11
    post.created_at.year.must_equal   2012
    post.created_at.hour.must_equal   6
    post.created_at.minute.must_equal 0
  end
end
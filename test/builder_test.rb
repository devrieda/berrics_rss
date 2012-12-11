require_relative "test_helper"

describe Builder do
  before do 
    @request = BerricsRss::TestRequest.new
  end

  it "must fetch posts" do
    posts = BerricsRss::Builder.new(:request => @request).send(:fetch_posts)
    
    posts.size.must_equal 3

    post = posts[1]
    post.title.must_equal   "Two Baby Millionaires And Dominick S.K.A.T.E. The 5's"
    post.url.must_equal     "http://theberrics.com/gen-ops/unsanctioned-event-battle-lines.html"
    post.body.must_include  "With BATB 6 coming up"

    post.created_at.month.must_equal 12
    post.created_at.day.must_equal   11
    post.created_at.year.must_equal  2012
  end
  
  it "must create RSS" do
    xml = BerricsRss::Builder.new(:request => @request).xml

    xml.must_include("<title>Pizza With Danny")
    xml.must_include("<title>Two Baby Millionaires")
    xml.must_include("<title>Process")
  end
end
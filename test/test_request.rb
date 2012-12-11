module BerricsRss
  class TestRequest
    def initialize(params={})
    end

    def get_page(url)
      path = self.class.test_pages.select {|k,v| v == url }.first[0]
      File.read "test/tmp/#{path}.html"
    end

    def self.test_pages
      {:dailyops => "http://theberrics.com/dailyops"}
    end
  end
end
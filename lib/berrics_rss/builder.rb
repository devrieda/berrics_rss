module BerricsRss
  URL = "http://theberrics.com/dailyops"

  class Builder
    attr_accessor :request

    def initialize(params={})
      @request = params[:request] || Request.new
    end
    
    def write(path)
      File.open(path, 'w') {|f| f.write(xml) }
    end

    def xml
      build_xml(fetch_posts)
    end


    private

    def fetch_posts
      body = request.get_page(URL)

      # find posts
      doc = Nokogiri::HTML(body)

      posts = []
      doc.css(".standard-post").each do |post|
        next unless anchor = post.css("h1 a")[0]

        posts << Post.new(:title => anchor.text,
                          :url   => "http://theberrics.com#{anchor["href"]}",
                          :body  => post.css(".text-content p").text.strip,
                          :date  => post.css(".date").text.strip,
                          :time  => post.css(".time").text.strip)
      end

      posts
    end

    def build_xml(posts)
      # build rss
      xml = ::Builder::XmlMarkup.new(:indent => 2)
      xml.instruct! :xml, :version => '1.0'
      xml.rss :version => "2.0" do
        xml.channel do
          xml.title "The Berrics - Daily Ops"
          xml.link "http://theberrics.com/dailyops"
          xml.description "The Berrics - Daily Ops"
          xml.language "en-us"

          posts.each do |post|
            xml.item do
              xml.title       post.title
              xml.link        post.url
              xml.description post.body
              xml.pubDate     post.created_at.rfc822
              xml.guid        post.url
            end
          end
        end
      end
      
      xml.target!
    end
  end

end
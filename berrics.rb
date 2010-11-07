require 'time'
require 'open-uri'

require 'rubygems'
require 'hpricot'
require 'builder'

class Post
  attr_accessor :title, :url, :body, :created_at

  def initialize(options = {})
    @title      = options[:title]       || ""
    @url        = options[:url]         || ""
    @body       = options[:body]        || ""
    @created_at = options[:created_at]  || ""
  end
end

agent    = "Ruby/#{RUBY_VERSION}"
url      = "http://www.theberrics.com/dailyops.php"
response = ''

# open-uri RDoc: http://stdlib.rubyonrails.org/libdoc/open-uri/rdoc/index.html
open(url, "User-Agent" => agent) {|f| response = f.read }

doc = Hpricot(response)

@posts = []
doc.search("div#vptop/h3/a").each do |link| 
  @posts << Post.new(:title => link.inner_html, 
                     :url   => link.get_attribute("href"))
end

doc.search("div#vpbot/p").each_with_index do |meta, i|
  next unless meta.inner_text.match /POSTED/

  # reformat date
  pattern = /.*(\d\d:\d\d)\s*([\d]{1,2}\.[\d]{1,2}\.)(\d\d) .*/
  text = meta.inner_text.gsub(pattern, '\220\3 \1').gsub('.', '/')

  @posts[i].created_at = Time.parse(text)
end

# weekend posts
if @posts.size == 0 
  doc.search("div#vptop/h3").each do |h3| 
    @posts << Post.new(:title      => "Weekend Post: #{h3.inner_html}", 
                       :url        => 'http://theberrics.com/dailyops.php', 
                       :created_at => Time.parse(Time.now.strftime("%m/%d/%Y")))
  end
end

xml = ::Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Berrics - Daily Ops"
    xml.link "http://www.theberrics.com/dailyops.php"
    xml.description "The Berrics - Daily Ops"
    xml.language "en-us"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link  post.url
        xml.description post.body
        xml.pubDate Time.parse(post.created_at.to_s).rfc822()
        xml.guid post.url
      end
    end
  end
end

File.open File.dirname(__FILE__) + '/public/index.rss', 'w' do |f|
  f.write xml.target!
end

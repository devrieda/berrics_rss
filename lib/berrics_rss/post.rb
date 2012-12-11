module BerricsRss
  class Post
    attr_accessor :url, :body
  
    def initialize(options = {})
      @title = options[:title] || ""
      @url   = options[:url]   || ""
      @body  = options[:body]  || ""
      @date  = options[:date]  || ""
      @time  = options[:time]  || ""
    end
    
    def title
      @title.downcase.gsub(/\b('?[a-z])/) { $1.capitalize }.strip
    end

    def created_at
      DateTime.strptime("#{@date} #{@time}", "%m-%d-%Y %I:%M %p")
    end
  end
end
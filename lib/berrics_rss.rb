require 'time'
require 'benchmark'
require 'net/http'
require 'uri'

require "nokogiri"
require "builder"

require "berrics_rss/version"
require "berrics_rss/post"
require "berrics_rss/builder"

module BerricsRss
  # Request

  def self.request=(request)
    @request = request
  end

  def self.request
    @request ||= Request.new
  end
  
  # Instantiate a request for a source page
  #
  class Request
    # we're firefox...
    USER_AGENT = "Ruby/#{RUBY_VERSION}"
    
    attr_reader :response_time, :parse_time

    @@last_request = Time.now

    # default throttle requests 1 per sec
    def initialize(params={})
      @throttle = params[:throttle] || 1
    end

    def get_page(url)
      throttle

      # perform request
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Get.new(uri.request_uri)
      request["User-Agent"] = USER_AGENT

      response = http.request(request)

      # redirect
      @prev_redirect ||= ""
      if response.header['location']
        # make sure we're not in an infinite loop
        if response.header['location'] == @prev_redirect
          raise HTTPError, "Recursive redirect: #{@prev_redirect}"
        end
        @prev_redirect = response.header['location']

        return get_page(response.header['location'])
      end

      # bad req
      if response.to_s.index 'Bad Request' || response.nil?
        raise HTTPError, "invalid HTTP request #{url}" 
      end

      # Use charset in content-type, default to UTF-8 if absent
      # 
      # text/html; charset=UTF-8
      # - or -
      # text/html; charset=iso-8859-1
      # - or - 
      # text/html
      charset = if response.header["Content-Type"].to_s.include?("charset")
        response.header["Content-Type"].split(";")[1].split("=")[1]
      else
        "UTF-8"
      end

      response.body.force_encoding(charset.upcase).encode("UTF-8")
      response.body
    end


    private

    # throttle requests to 1 per sec
    def throttle
      sleep @throttle if @@last_request + @throttle > Time.now
      @@last_request = Time.now
    end
  end
  
end

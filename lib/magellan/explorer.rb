require 'net/http'
require 'magellan/extensions/string'
require 'magellan/extensions/http_response'

module Magellan
  class Explorer

    def explore(url)
      response = web_response(url)
      Result.new(response.code,response.linked_resources)
    end
    
    def web_response(url)
      #TODO: fix proxy support
      uri = URI.parse("http://#{url}")
      req = Net::HTTP::Get.new(uri.path)
      res = nil
      Net::HTTP.start(uri.host,uri.port) {|http|
        res = http.request(req)
      }
      res
    end
  end
  
  class Result
    attr_reader :status_code, :linked_resources
    def initialize(status_code, linked_resources)
      @status_code = status_code
      @linked_resources = linked_resources
    end
  end
end
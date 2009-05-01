require 'hpricot'
require 'open-uri'
require 'ostruct'

module Magellan
  class Explorer # :nodoc:
    UNKNOWN_CONTENT = "unknown"
    def initialize(urls,links) # :nodoc:
      @links = links
      @urls = urls
    end

    def explore # :nodoc:
      reqs = []
      @urls.each do |url|
        reqs.push Thread.new { explore_a(url) }
      end
      reqs.collect { |req| req.value }
    end

    def explore_a(url) # :nodoc:
      begin
        agent = WWW::Mechanize.new
        agent.user_agent = "Ruby/#{RUBY_VERSION}"
        doc = agent.get(url)
        destination_url = doc.uri.to_s
        status_code = doc.code
        #TODO: clean this up, this is very hacky, I would rather pass in a hpricot doc to create a result
        if doc.respond_to?(:content_type) && doc.content_type.starts_with?("text/html")
          Explorer.create_result(url, destination_url, status_code, doc.links_to_other_documents(@links),doc.content_type,doc)
        else
          Explorer.create_result(url, destination_url, status_code, [], doc.respond_to?(:content_type) ? doc.content_type : UNKNOWN_CONTENT,doc)
        end
      rescue WWW::Mechanize::ResponseCodeError => the_error
        Explorer.create_result(url, url, the_error.response_code, [],UNKNOWN_CONTENT,doc)
      rescue Timeout::Error
        Explorer.create_result(url, url, "504", [],UNKNOWN_CONTENT,doc)
      end
    end

    def self.create_result(url,destination_url,status_code,links,content_type,doc) # :nodoc:
      input = {:status_code => status_code,:url => url,:destination_url => destination_url, :status_code => status_code, :linked_resources => links.map{|link| link.to_s}, :content_type => content_type, :document => doc}
      Result.new(input)
    end
  end
end

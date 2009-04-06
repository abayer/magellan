require 'activesupport'
require 'observer'

module Magellan
  class Cartographer
    include Observable

    def initialize(settings)
      @origin_url = settings[:origin_url]
      @known_urls = settings[:ignored_urls]
      @domains = settings[:domains].map {|domain| URI.parse(domain)}
      @depth_to_explore = settings[:depth_to_explore]
    end

    def crawl
      recursive_explore([@origin_url],1)
    end

    def recursive_explore(urls,depth)
      if i_am_not_too_deep?(depth)
        results = Explorer.new(urls).explore
        results.each do |result|
          changed
          notify_observers(Time.now, result)
          @known_urls << result.url.remove_fragment
          @known_urls << result.destination_url.remove_fragment
          remove_javascript_and_print_warning result
        end

        all_urls = results.map {|result| result.absolute_linked_resources }.flatten
        all_urls.uniq!
        #TODO: handle any other url parsing error
        all_urls.delete_if { |url| !a_domain_we_care_about?(url)}
        all_urls.delete_if { |url| i_have_seen_this_url_before?(url)}
        all_urls.chunk(40).each do |result_chunk|
          
          recursive_explore(result_chunk,depth+1)
        end
      end
    end

    def i_have_seen_this_url_before?(url)
      @known_urls.include?(url.remove_fragment)
    end

    def i_am_not_too_deep?(depth)
      depth <= @depth_to_explore
    end

    def a_domain_we_care_about?(url)
      begin
        !@domains.select { |domain| URI.parse(url).host == domain.host }.empty?
      rescue
        !@domains.select { |domain| url.gsub(/https*:\/\//,'').starts_with?(domain.host) }.empty?
      end
    end

    def remove_javascript_and_print_warning(result)
      result.linked_resources.delete_if do |linked_resource|
        starts_with_javascript = linked_resource.downcase.starts_with?("javascript:")
        #TODO: put this in the logger
        #$stderr.puts "Found obtrusive javascript: #{linked_resource} on page #{result.url}" if starts_with_javascript
        starts_with_javascript
      end
    end

  end
end

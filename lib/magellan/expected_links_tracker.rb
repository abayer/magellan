module Magellan
  class ExpectedLinksTracker
    include Observable
    attr_reader :errors

    def initialize(expected_patterns)
      @errors = []
      @expected_patterns = expected_patterns
      @evaluated_expectations = {}
    end

    def update(time,result)
      if result.html_content?
        patterns_that_apply(result).each do |pattern,expectation|
          passed = result.linked_resources.include?(expectation)
          changed
          notify_observers(Time.now, passed)
          @errors << "#{result.url} did not contain a link to #{expectation}" unless passed
        end
      end
    end

    def patterns_that_apply(result)
      res = @expected_patterns.select{|pattern,expecation| result.url =~ pattern || result.destination_url =~ pattern}
      res.each { |expected_pattern| @evaluated_expectations[expected_pattern] = nil }
      res
    end

    def has_errors?
      !@errors.empty?
    end

    def unmet_expecations?
      !unmet_expecations.empty?
    end

    def failed?
      unmet_expecations? || has_errors?
    end

    def failure_message
      unmet_expecations_messages << errors.join("\n")
    end

    def unmet_expecations_messages
      message = ""
      unmet_expecations.each {|pattern,unmet_expecation| message << "#{pattern} was never evaluted during the crawl\n"}
      message
    end

    def unmet_expecations
      @expected_patterns - @evaluated_expectations.keys
    end
  end
end

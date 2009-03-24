require 'activesupport'
require 'open-uri'
class String
  def to_absolute_url(origin_url)
    begin
      URI.join(origin_url,self.strip).to_s
    rescue URI::InvalidURIError => the_error
      $stderr.puts "#{self} did not appear to be a valid url"
      nil
    end
  end

  def remove_fragment
    self.gsub(/#.*/,'')
  end
end

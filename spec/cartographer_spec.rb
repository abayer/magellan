require File.dirname(__FILE__) + '/spec_helper'
require 'magellan'

describe Magellan::Cartographer do

  it "should not visit the same url more then once" do
    origin_url = "http://www.google.com"
    Magellan::Explorer.any_instance.expects(:explore).once.with(origin_url).returns(create_success_result(['http://www.google.com']))
    cartographer = Magellan::Cartographer.new(origin_url)
    cartographer.crawl
  end

  it "should explorer other linked resources" do
    origin_url = "http://www.google.com"
    Magellan::Explorer.any_instance.expects(:explore).with(origin_url).returns(create_success_result(['http://www.google.com/foo.html']))
    Magellan::Explorer.any_instance.expects(:explore).with('http://www.google.com/foo.html').returns(create_success_result([]))
    cartographer = Magellan::Cartographer.new(origin_url)
    cartographer.crawl
  end

  it "should be able to specify crawlable domains" do
    origin_url = "http://www.google.com"
    Magellan::Explorer.any_instance.expects(:explore).once.with(origin_url).returns(create_success_result(['http://www.foo.com']))
    Magellan::Explorer.any_instance.expects(:explore).once.with('http://www.foo.com').returns(create_success_result(['http://www.bar.com']))
    cartographer = Magellan::Cartographer.new(origin_url, 5,['http://www.google.com','http://www.foo.com'])
    cartographer.crawl
  end

  it "should go n layers deep into a site" do 
    origin_url = "http://www.google.com"
    Magellan::Explorer.any_instance.expects(:explore).once.with(origin_url).returns(create_success_result(['http://www.google.com/foo.html']))
    Magellan::Explorer.any_instance.expects(:explore).once.with('http://www.google.com/foo.html').returns(create_success_result(['http://www.google.com/foo2.html']))
    Magellan::Explorer.any_instance.expects(:explore).once.with('http://www.google.com/foo2.html').returns(create_success_result(['http://www.google.com/foo3.html']))
    cartographer = Magellan::Cartographer.new(origin_url,3)
    cartographer.crawl    
  end
  
  it "should go through a entire site if layers to explore is set to -1"
  it "should explore n layers into external domains"

  def create_success_result(urls)
    Magellan::Result.new("http://www.google.com",200,urls)
  end
end
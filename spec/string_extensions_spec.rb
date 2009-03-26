require File.dirname(__FILE__) + '/spec_helper'
require 'magellan'

describe "String Extensions" do
  
  it "should convert relative urls to absolute" do
    input = '/Test_Automation_Framework/chrome/common/js/trac.js'
    input.to_absolute_url('http://www.google.com').should eql('http://www.google.com/Test_Automation_Framework/chrome/common/js/trac.js')
  end

  it "should remove any relative path from original url" do
    input = '/foo/trac.js'
    input.to_absolute_url('http://www.google.com/something/index.html').should eql('http://www.google.com/foo/trac.js')
  end

  it "should merge urls correctly with dots" do
    input = '../foo/trac.js'
    input.to_absolute_url('http://www.google.com/something/index.html').should eql('http://www.google.com/foo/trac.js')
  end

  it "should do nothing to absolute http urls" do
    input = 'http://www.apple.com'
    input.to_absolute_url('http://www.google.com').should eql('http://www.apple.com')
  end
  
  it "should not put double slashes when converting absolute to relative" do
    input = "/intl/en/about.html"
    input.to_absolute_url('http://www.google.com/').should eql('http://www.google.com/intl/en/about.html')
  end
  
  it "should do nothing to absolute https urls" do
    input = 'https://www.apple.com'
    input.to_absolute_url('http://www.google.com').should eql('https://www.apple.com')
  end
  
  it "should translate relative https urls to absolute" do
    input = "/intl/en/about.html"
    input.to_absolute_url('https://www.google.com/').should eql('https://www.google.com/intl/en/about.html')
  end
  
  it "should translate relative urls to absolute ones" do
    "/intl/en/about.html".to_absolute_url("http://www.google.com").should eql('http://www.google.com/intl/en/about.html')
  end

  it "should not translate absolute urls" do
    "http://video.google.com/foo/about.html".to_absolute_url("http://www.google.com").should eql("http://video.google.com/foo/about.html")
  end
  
  it "should return string itself if uri parse fails" do
    "something not a url".to_absolute_url("http://www.google.com").should eql("something not a url")
  end
  
  it "should chomp the fragment portion off the url" do
    "http://video.google.com/foo/about.html#sdkfjskajflsajf".remove_fragment.should eql("http://video.google.com/foo/about.html")
  end
  
  it "should strip spaces off of the input url" do
    input = ' http://www.apple.com'
    input.to_absolute_url('http://www.google.com').should eql('http://www.apple.com')
  end

end
require File.dirname(__FILE__) + '/spec_helper'
require 'magellan/extensions/string'

describe "String Extensions" do

  it "should get all anchor href links out of a string" do
    input = 'fjkasjfklasjflksjf <a href="http://www.nytimes.com/2008/11/06/us/politics/07elect.html?hp">Rahm Emanuel Accepts Post as White House Chief of Staff</a> akfj <a class="offsite ct-lifestyle" href="/services/">The Ultimate Guide to Stress Relief</a>'
    input.links.should include('/services/')
    input.links.should include('http://www.nytimes.com/2008/11/06/us/politics/07elect.html?hp')
  end

  it "should get all src links out of a string" do
    input = ' <script type="text/javascript" src="/Test_Automation_Framework/chrome/common/js/trac.js"></script></head><body>'
    input.links.should include('/test_automation_framework/chrome/common/js/trac.js')
  end

  it "should not care about case when it looks for links" do
    input = ' <script type="text/javascript" SRC="/Test_Automation_Framework/chrome/common/js/trac.js"></script></head><body>'
    input.links.should include('/test_automation_framework/chrome/common/js/trac.js')
  end

  it "should convert relative urls to absolute" do
    input = '/Test_Automation_Framework/chrome/common/js/trac.js'
    input.to_absolute_url('http://www.google.com').should eql('http://www.google.com/Test_Automation_Framework/chrome/common/js/trac.js')
  end

  it "should remove any relative path from original url" do
    input = '/foo/trac.js'
    input.to_absolute_url('http://www.google.com/something/index.html').should eql('http://www.google.com/foo/trac.js')
  end

  it "should do nothing to absolute urls" do
    input = 'http://www.apple.com'
    input.to_absolute_url('http://www.google.com').should eql('http://www.apple.com')
  end
  
end
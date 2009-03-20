require 'rake'
require 'rake/tasklib'
require 'magellan'

module Magellan
  module Rake
    
    #example usage:
    #Magellan::Rake::Task.new do |t|
    #  t.origin_url = "http://localhost:3000/"
    #  t.explore_depth = 100
    #end
    class Task < ::Rake::TaskLib
      attr_accessor :origin_url
      attr_accessor :explore_depth

      def initialize(name="magellan:explore")
        @name=name
        yield self if block_given?
        define
      end

      def define
        desc "explore #{@origin_url}"
        task @name do
          cartographer = Magellan::Cartographer.new(@origin_url,@explore_depth)
          cartographer.crawl
        end
      end

    end

  end
end

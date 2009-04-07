module Magellan
  class Logger
    def initialize(file_name=nil)
      @file_name = file_name
    end
    
    def update(time,passed,message)
      $stdout.putc(passed ? '.' : 'F')
      $stdout.flush
      File.open(@file_name, 'a') {|f| f.write(message + "\n") } if @file_name && !passed
    end
  end
end
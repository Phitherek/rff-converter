#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  Conversion.completed.each do |c|
     if c.updated_at < Time.now-7.days
         Rails.logger.info "Cleanup: Destroying conversion with key: #{c.key.to_s}\n"
         c.destroy!
     end
  end
  
  Rails.logger.info "Cleanup daemon is still running at #{Time.now}.\n"
  
  sleep 600
end

class ApplicationController < ActionController::Base
  require 'sys/filesystem'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :load_stats
  
  protected
  
  def load_stats
     @processing_count = Conversion.processing.count
     diskstat = Sys::Filesystem.stat("#{Rails.root}/public/")
     @available_disk_space = ((diskstat.block_size * diskstat.blocks_available).to_f/1024/1024/1024).round(2)
  end
end

class ApplicationController < ActionController::Base
  require 'sys/filesystem'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :load_stats
  
  def render_error error
    if error.to_s == "forbidden"
      render "errors/forbidden", :status => :forbidden, :layout => "error" and return
    elsif error.to_s == "notfound"
      render "errors/notfound", :status => :not_found, :layout => "error" and return
    end
  end
  
  protected
  
  def load_stats
     @processing_count = Conversion.processing.count
     diskstat = Sys::Filesystem.stat("#{Rails.root}/public/")
     @available_disk_space = ((diskstat.block_size * diskstat.blocks_available).to_f/1024/1024/1024).round(2)
  end
end

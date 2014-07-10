class KeysController < ApplicationController
    
  before_filter :find_object
    
  def show
      respond_to do |format|
          format.html
          format.json do
              render :json => @obj.to_json_status
          end
      end
  end
  
  private
  
  def find_object
      @obj = Conversion.find_by_key(params[:key])
  end
end

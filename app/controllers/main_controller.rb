class MainController < ApplicationController
    def blank
    end
    
    def welcome
    end
    
    def conversion
        @conv = Conversion.new
        @conv.key = Key.generate
        @conv.original_file = params[:original_file]
        @conv.convtype = params[:type].to_sym
        @conv.mode = params[:processing].to_sym
        @conv.status = :new
        @conv.percentage = 0
        if !@conv.save
            @conv.key.destroy
            flash[:error] = "Conversion could not be started: #{@conv.errors.messages.to_s}. Please try again."
            redirect_to root_path
        end
        ConversionWorker.perform_async(@conv.key.to_s)
    end
    
    def stats
        respond_to do |format|
            format.json do
               load_stats
               render :json => [@processing_count, @available_disk_space].to_json 
            end
        end
    end
end

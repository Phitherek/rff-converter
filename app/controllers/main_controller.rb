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
            puts @conv.errors.to_yaml
            flash[:error] = "Conversion could not be started, probably because of wrong form data. Please try again."
            redirect_to root_path
        end
        ConversionWorker.perform_async(@conv.key.to_s)
    end
end

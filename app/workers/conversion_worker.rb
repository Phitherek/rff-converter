class ConversionWorker
    include Sidekiq::Worker
    sidekiq_options :retry => false
    require 'fileutils'
    require 'zip'
    
    def perform(key)
        @conv = Conversion.find_by_key(key)
        if !@conv.nil?
            @conv.convtype = @conv.convtype.to_sym
            @conv.mode = @conv.mode.to_sym
            @conv.status = @conv.status.to_sym
            handler = nil
            if @conv.convtype == :audio
                handler = RFF::AudioHandler.new(@conv.original_file.path, "#{Rails.root}/public/conversions/#{key}/files/")
            elsif @conv.convtype == :video
                handler = RFF::VideoHandler.new(@conv.original_file.path, "#{Rails.root}/public/conversions/#{key}/files/")
            end
            if !handler.nil?
                if @conv.mode == :concurrent
                    handler.fire_all
                elsif @conv.mode == :sequential
                    handler.fire_sequential
                end
                @conv.status = :processing
                @conv.save!
                while handler.processing_percentage < 100
                    @conv.percentage = handler.processing_percentage
                    @conv.save!
                    sleep 1
                end
                if @conv.convtype == :audio
                   if (!handler.mp3_processor || handler.mp3_processor.status == :completed) && (!handler.ogg_processor || handler.ogg_processor.status == :completed) && (!handler.wav_processor || handler.wav_processor.status == :completed)
                       @conv.status = :completed
                   else
                       @conv.status = :failed
                       @conv.debuginfo1 = "Status: " + handler.mp3_processor.status.to_s + "\n" + handler.mp3_processor.raw_command_output.join("\n") if handler.mp3_processor
                       @conv.debuginfo2 = "Status: " + handler.ogg_processor.status.to_s + "\n" + handler.ogg_processor.raw_command_output.join("\n") if handler.ogg_processor
                       @conv.debuginfo3 = "Status: " + handler.wav_processor.status.to_s + "\n" + handler.wav_processor.raw_command_output.join("\n") if handler.wav_processor
                   end
                elsif @conv.convtype == :video
                    if (!handler.mp4_processor || handler.mp4_processor.status == :completed) && (!handler.ogv_processor || handler.ogv_processor.status == :completed) && (!handler.webm_processor || handler.webm_processor.status == :completed)
                       @conv.status = :completed
                   else
                       @conv.status = :failed
                       @conv.debuginfo1 = "Status: " + handler.mp4_processor.status.to_s + "\n" + handler.mp4_processor.raw_command_output.join("\n") if handler.mp4_processor
                       @conv.debuginfo2 = "Status: " + handler.ogv_processor.status.to_s + "\n" + handler.ogv_processor.raw_command_output.join("\n") if handler.ogv_processor
                       @conv.debuginfo3 = "Status: " + handler.webm_processor.status.to_s + "\n" + handler.webm_processor.raw_command_output.join("\n") if handler.webm_processor
                   end
                end
                if @conv.status == :completed
                    Zip::File.open("#{Rails.root}/public/conversions/#{key}.zip", Zip::File::CREATE) do |zip|
                        Dir[File.join("#{Rails.root}/public/conversions/#{key}/files/", '**', '**')].each do |f|
                            zip.add(f.sub("#{Rails.root}/public/conversions/#{key}/files/", ''), f)
                        end
                    end
                    @conv.zippath = "#{Rails.root}/public/conversions/#{key}.zip"
                end
                @conv.save!
                FileUtils.rm_r("#{Rails.root}/public/conversions/#{key}/")
            else
                @conv.status = :failed
                @conv.save!
            end
        end
    end
end

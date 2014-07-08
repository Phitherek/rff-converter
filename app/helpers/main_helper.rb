module MainHelper
    def conversion_types_for_select
        [["Audio", :audio], ["Video", :video]]
    end
    
    def processing_types_for_select
        [["Concurrent (may significantly slow down the server)", :concurrent], ["Sequential (may take longer)", :sequential]]
    end
end

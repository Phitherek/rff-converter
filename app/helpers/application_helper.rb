module ApplicationHelper
    def current_hostname
        request.protocol + request.host + request.port_string
    end
end

module ApplicationHelper
    def show_field_error(model, field)
        s=""

        if !model.errors[field].empty?
            s = 
            <<-EOHTML
            <div id="error_message">
                #{model.errors[field][0]}
            </div>
            EOHTML
        end
        s.html_safe
    end

    def show_message(messages, field)
        s=""

        if !messages[field].empty?
            s = 
            <<-EOHTML
            <div id="message">
                #{messages[field][0]}
            </div>
            EOHTML
        end
        s.html_safe
    end
end

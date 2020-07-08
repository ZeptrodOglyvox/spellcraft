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

    def i2ord(i)
        return i.to_s + "th" if (11..13).include? i%100
        
        i.to_s + 
        case i%10
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else        "th"
        end
    end
end

module ApplicationHelper
    def show_field_error(model, field) # TODO put error display in a partial and render it in views
        if !model.nil?
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

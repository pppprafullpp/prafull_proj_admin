module Paperclip
    module Interpolations
        def user_id_for_report attachment, style_name
            attachment.instance.lab_order.user_id
        end
        
        def user_id attachment, style_name
            attachment.instance.id
        end
        
        def lab_id attachment, style_name
            attachment.instance.lab_id
        end
        
        def lab_id_for_logo attachment, style_name
            attachment.instance.id
        end
        
        def doctor_id attachment, style_name
            attachment.instance.id
        end
    end
end
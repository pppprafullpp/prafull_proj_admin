class StaticController < ApplicationController
    def blog_header_partial
      render :partial => 'home/home_header'
    end
    
    def blog_footer_partial
      render :partial => 'static/footer'
    end
    
    def blog_copyright_partial
      render :partial => 'home/copyright'
    end
end

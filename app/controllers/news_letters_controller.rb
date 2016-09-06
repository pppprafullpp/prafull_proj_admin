class NewsLettersController < ApplicationController
  layout "home"
  
  def add_news_letters()
     @news_letters = NewsLetter.new()
     @news_letters.email = params['email']
     @error = false
    if @news_letters.valid? && @news_letters.save
      @error = false
    else
      @error = true
    end
    respond_to do |format|
      format.js
    end
  end
  
end

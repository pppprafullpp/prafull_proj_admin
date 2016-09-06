class JsonStatus

  def self.validate_request(ex,parameter_hash)
    if ex
      #      status = "'status_code':500,'status_message':'FAIL','status_details':''"
      return 500,'FAIL',ex
    else
      #      status = "{'status_code':200,'status_message':'SUCCESS','status_details':''}"
      return 200,'SUCCESS',''
    end
    
  end
end
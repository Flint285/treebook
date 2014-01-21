class TestRun < ActionMailer::Base
  default from: "from@example.com"

  def help_request( status_id, user )
    #@greeting = "Hi"
    @status = Status.find( status_id ) 
    @user = user 
    mail to: @user.email,
  		 subject: "Help Needed!"  
    
  end
end

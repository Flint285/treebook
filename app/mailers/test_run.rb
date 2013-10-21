class TestRun < ActionMailer::Base
  default from: "from@example.com"

  def help_request( status_id )
    @greeting = "Hi"
    @status = Status.find( status_id ) 

  	mail to: "Flint285@gmail.com",
  		 subject: "My first ever Help Request"

  end
end

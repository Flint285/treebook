class Status < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user 


  validates :content, presence: true,
  					  length: { minimum: 2 }

  validates :user_id, presence: true

  after_save :help_requests

  def help_requests
  	TestRun.help_request( id ).deliver
  end 
end

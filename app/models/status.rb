class Status < ActiveRecord::Base 
  attr_accessible :content, :skill_ids, :document_attributes
  belongs_to :user
  belongs_to :document

  accepts_nested_attributes_for :document 
  #belongs_to :skill
  has_and_belongs_to_many :skills

  validates :content, presence: true,
  					  length: { minimum: 2 }

  validates :user_id, presence: true

  #after_create on: :new_car, do: :help_requests
  #after_create :computer_help#, only: [:new_computer?]

  def help_requests
    users = User.all
    users.each do |user|
      if user.skills.find_by_title( "Car" )  
  	    TestRun.help_request( id, user ).deliver
      end  
    end
  end 

  def computer_help
      users = User.all
      users.each do |user|
        if user.skills.find_by_title( "Computer" )  
          TestRun.help_request( id, user ).deliver
        end
      end  
    end   

end


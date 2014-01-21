class Skill < ActiveRecord::Base
  attr_accessible :level, :rating, :title #:users_id
  #belongs_to :user
  #has_many :statuses
  has_and_belongs_to_many :users
  has_and_belongs_to_many :statuses


end

class RemoveAFewIdColumns < ActiveRecord::Migration
  def up
    remove_column :skills, :user_id
    remove_column :statuses, :user_id
    remove_column :statuses, :skill_id 
  end
end

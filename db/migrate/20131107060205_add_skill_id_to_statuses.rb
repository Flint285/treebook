class AddSkillIdToStatuses < ActiveRecord::Migration
  def change
  	add_column :statuses, :skill_id, :integer
  	add_index :statuses, :skill_id
  end
end

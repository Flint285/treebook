class AddSkillsJoinTablePart2 < ActiveRecord::Migration
  def change
  	create_table :skills_statuses, id: false do |t|
      t.references :skill
      t.references :status
  end

  add_index :skills_statuses,     [:skill_id, :status_id]
  
  end
end

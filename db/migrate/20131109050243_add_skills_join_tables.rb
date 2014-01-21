class AddSkillsJoinTables < ActiveRecord::Migration
  def change
    create_table :skills_users, id: false do |t|
      t.references :skill
      t.references :user
  end

  create_table :statuses_skills, id: false do |t|
    t.references :skill
    t.references :status
  end

  add_index :skills_users,        [:skill_id, :user_id]
  add_index :statuses_skills,     [:skill_id, :status_id]
 
  end
end

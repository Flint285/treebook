class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :title
      t.string :level
      t.integer :rating
      t.references :user

      t.timestamps
    end
    add_index :skills, :user_id
  end
end

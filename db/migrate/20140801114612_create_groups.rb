class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.boolean :public
      t.string :avatar
      t.integer :user_id
      t.text :description
      t.boolean :always_on_top

      t.timestamps
    end
  end
end

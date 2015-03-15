class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :message
      t.boolean :global, default: false
      t.integer :group_id
      t.integer :parent_id
      t.integer :user_id

      t.timestamps
    end
  end
end

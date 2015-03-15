class CreateFriendUsers < ActiveRecord::Migration
  def change
    create_table :friend_users do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :status

    end
    add_index(:friend_users, [:user_id, :friend_id], unique: true)
  end
end

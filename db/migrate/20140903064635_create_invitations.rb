class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end

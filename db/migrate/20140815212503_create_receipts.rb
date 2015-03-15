class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :user_id
      t.integer :message_id
      t.boolean :is_read, default: false
      t.string :mail_type

      t.timestamps
    end
  end
end

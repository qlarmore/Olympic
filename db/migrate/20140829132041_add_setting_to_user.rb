class AddSettingToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_status, :boolean, default: true
    add_column :users, :show_birthbay, :boolean, default: true
    add_column :users, :show_number, :boolean, default: true
    add_column :users, :invite_to_friend, :boolean, default: true
    add_column :users, :write_on_page, :boolean, default: true
    add_column :users, :show_image, :boolean, default: true
    add_column :users, :comment_post, :boolean, default: true
    add_column :users, :write_private_message, :boolean, default: true
  end
end

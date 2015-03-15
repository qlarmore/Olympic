class AddLastActivityToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_activity, :datetime
    add_column :users, :online, :boolean, default: false
  end
end

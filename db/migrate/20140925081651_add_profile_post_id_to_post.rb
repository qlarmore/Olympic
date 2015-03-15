class AddProfilePostIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :profile_post_id, :integer
  end
end

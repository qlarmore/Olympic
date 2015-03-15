class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :avatar
      t.string :post_id

      t.timestamps
    end
  end
end

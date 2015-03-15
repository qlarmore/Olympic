class Group < ActiveRecord::Base
  has_many :posts, -> { where(parent_id: nil).order(created_at: :desc) }
  has_many :group_users
  has_many :users, through: :group_users
  belongs_to :user

  mount_uploader :avatar, AvatarUploader

  def random_users
    users.order("RAND()").limit(10)
  end

end

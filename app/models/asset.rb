class Asset < ActiveRecord::Base
  belongs_to :post
  belongs_to :message

  mount_uploader :avatar, AvatarUploader
end

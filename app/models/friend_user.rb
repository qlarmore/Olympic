class FriendUser < ActiveRecord::Base
  belongs_to :friend
  belongs_to :user
end

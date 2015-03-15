class Message < ActiveRecord::Base
  belongs_to :user
  has_many :assets, dependent: :destroy
  has_many :receipts, dependent: :destroy
  belongs_to :conversation

  validates :message, presence: true

  def mark_as_read!(user)
    receipts.where(user_id: user.id).first.update_column(:is_read, true)
  end
end
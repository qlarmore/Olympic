class Conversation < ActiveRecord::Base

  has_many :messages, dependent: :destroy
  has_many :receipts, -> { uniq }, through: :messages
  has_many :users, -> { uniq }, through: :receipts

  def creator
    users.first
  end

  def last_message
    messages.last
  end

  def mark_as_read(user)
    receipts.where(user_id: user.id).update_all(is_read: true)
    # WebsocketRails["message_count_#{user.id}"].trigger :message_count, user.unread_messages_count
    messages.includes([:assets, :user])
  end
end

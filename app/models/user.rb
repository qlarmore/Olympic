#encoding: UTF-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  ROLES = %w|user super admin|

  acts_as_voter
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:nick_name]

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, :nick_name, :birthday, :role, :number, presence: true
  validates :nick_name, :number, uniqueness: true

  has_many :created_posts, foreign_key: :user_id, class_name: Post
  has_many :posts, -> { order(created_at: :desc) }, foreign_key: :profile_post_id, class_name: Post
  has_many :group_users
  has_many :groups_if_member, through: :group_users, source: :group
  has_many :groups
  has_many :receipts, -> { uniq }
  has_many :messages, -> { uniq }, through: :receipts
  has_many :conversations, -> { uniq }, through: :messages
  has_many :invitations

  scope :not, ->(id) { where("id != ?", id) }
  scope :search, ->(query) { where("nick_name LIKE :query OR first_name LIKE :query OR last_name LIKE :query OR CONCAT_WS(' ', first_name, last_name) LIKE :query", query: "%#{query}%").last(10) if query.present?}

  def invitations
    Invitation.where("invitations.user_id = #{id} or invitations.friend_id = #{id}").uniq
  end

  def friends(status='approved')
    User.joins("LEFT JOIN invitations ON (users.id = invitations.user_id or users.id = invitations.friend_id)") 
        .where("invitations.user_id = #{id} or invitations.friend_id = #{id}")
        .where("invitations.status = ?", status)
        .where("users.id != #{id}").uniq
  end

  def add_to_friend(user)
    if inv = Invitation.where(user_id: [id, user.id], friend_id: [id, user.id], status: ['pending', 'rejected']).first
      inv.update_column(:status, 'approved')
    else
      Invitation.create({ user_id: id, friend_id: user.id, status: 'pending' })
    end
  end

  def remove_from_friend(user)
    inv = Invitation.where(user_id: [id, user.id], friend_id: [id, user.id], status: 'approved').first
    inv.update_column(:status, 'rejected') if inv
  end

  def friend?(user)
    Invitation.where(user_id: [id, user.id], friend_id: [id, user.id], status: 'approved').first
  end

  def invited?(user)
    Invitation.where(user_id: [id, user.id], friend_id: [id, user.id], status: 'pending').first
  end

  def rejected?(user)
    Invitation.where(user_id: [id, user.id], friend_id: [id, user.id], status: 'rejected').first
  end

  ROLES.each do |role|
    define_method(:"is_#{role}?") do
      self.role == role
    end
  end

  def email_required?
    false
  end

  def is_creator?(resource)
    groups.include?(resource)
  end

  def is_member?(resource)
    groups_if_member.include?(resource)
  end

  def is_owner?(resource)
    profile_posts.include?(resource)
  end

  def can_write_create_post?(resource)
    if resource.is_a?(User)
      true
    else
      is_member?(resource) || is_creator?(resource)
    end
  end

  def display_name
    first_name and last_name ? [first_name, last_name].join(' ') : nick_name
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def is_post_creator?(post)
    id == post.user_id
  end

  def status
    last_activity.try(:strftime, "Последняя активность: %d.%m в %H:%M:%S")
  end

  def send_message(user_ids, params)
    user_ids = user_ids.split(",")
    receipt = Receipt.includes(:message).where(messages: { user_id: id },user_id: user_ids).first || Receipt.includes(:message).where(messages: { user_id: user_ids }, user_id: id).first
    conversation = receipt ? receipt.message.conversation : Conversation.create
    if message = conversation.messages.create(params.merge({user_id: id, conversation_id: conversation.id}))
      user_ids.each do |user_id|
        Receipt.create(user_id: user_id, message_id: message.id, mail_type: 'inbox')
      end
      Receipt.create(user_id: id, message_id: message.id, mail_type: 'sendbox', is_read: true)
    end
    message
  end

  def reply_to_conversation(conversation_id, params)
    if conversation = Conversation.find_by_id(conversation_id)
      if message = conversation.messages.create(params.merge({user_id: id, conversation_id: conversation.id}))
        conversation.users.each do |user|
          Receipt.create(user_id: user.id, message_id: message.id, mail_type: user.id == id ?  'sendbox' : 'inbox', is_read: user.id == id)
        end
      end
    end
    message
  end

  def can_write_to_channel?(channel)
    conversations.find_by_id(channel)
  end

  def unread_messages
    messages.includes(:receipts).where(receipts: { is_read: false })
  end

  def unread_messages_for(conversation)
    messages.includes(:receipts).where(receipts: { is_read: false }, conversation_id: conversation.id)
  end

  def unread_messages_count
    unread_messages.size > 0 ? unread_messages.size : nil
  end

  def chatting?(conversation)
    false
  end

  def online?
    # binding.pry
    $redis.hgetall("olympicSession")["#{id}"]
  end

end

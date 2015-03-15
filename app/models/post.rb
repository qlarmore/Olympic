class Post < ActiveRecord::Base
  acts_as_votable
  acts_as_paranoid
  validates :message, presence: true
  has_many :comments, class_name: 'Post', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Post', foreign_key: 'parent_id'
  has_many :assets
  belongs_to :user
  belongs_to :group
  belongs_to :owner, class_name: User

  scope :top, -> { where(global: true).order("created_at desc") }

  def comment?
    parent_id
  end

  def destroy
    update_column(:deleted_at, Time.now)
  end

  def resource
    group_id ? group : owner
  end
  
end

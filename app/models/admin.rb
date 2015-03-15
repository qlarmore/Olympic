class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable, authentication_keys: [:nick_name]

  validates :first_name, :last_name, :nick_name, presence: true
  validates :nick_name, uniqueness: true

  def email_required?
    false
  end

end


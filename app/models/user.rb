# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  name_pretty     :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name_pretty, :email, :password, :password_confirmation
  has_secure_password
 
  def name_pretty=(val)
    self[:name_pretty] = val
    if val.respond_to?(:downcase)
      self[:name] = val.downcase
    end
  end

  before_save{ |user| user.email = email.downcase }
    
  VALID_NAME_REGEX = /\A[a-z0-9_\.]*\z/i
  validates :name_pretty, presence: true, format: { with: VALID_NAME_REGEX },
    length: { maximum: 50 }
  validates :name, uniqueness: { case_sensitive: false }
    
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  protected
  def name=(val)
    self[:name] = val
  end
  

end

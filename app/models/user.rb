class User < ActiveRecord::Base
  has_secure_password
  has_many :orders
  has_many :addresses


  validates :full_name, presence: true
  validates :email_address, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  validates :email_address, uniqueness: true

  # attr_accessible :name , :email

  # User::Roles
  # The available roles
  Roles = [ :admin , :user ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end

end

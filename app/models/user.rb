class User < ActiveRecord::Base
  has_secure_password
  has_many :restaurants
  has_many :online_orders
  has_many :addresses
  has_many :user_roles
  has_many :roles, through: :user_roles

  validates :full_name, presence: true
  validates :email_address, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :email_address, uniqueness: true

  def staff?(restaurant)
    cook?(restaurant) || delivery_person?(restaurant) || admin?(restaurant)
  end

  def cook?(restaurant)
    role = Role.find_by(name: 'cook')
    restaurant.user_roles.where(user_id: self.id, role_id: role.id).any?
  end

  def delivery_person?(restaurant)
    role = Role.find_by(name: 'delivery person')
    restaurant.user_roles.where(user_id: self.id, role_id: role.id).any?
  end

  def admin?(restaurant)
    role = Role.find_by(name: 'admin')
    restaurant.user_roles.where(user_id: self.id, role_id: role.id).any?
  end

  def verify?(role, restaurant)
    role = Role.find_by(name: role)
    user_roles.where(restaurant_id: restaurant.id, role_id: role.id).any?
  end
end

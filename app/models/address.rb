class Address < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates :street_address, presence: true
  validates :city, presence: true, format: { with: /\A[a-zA-Z\s]+\z/ }
  validates :state, length: {is: 2}, format: { with: /\A[a-zA-Z]+\z/ }
  validates :zip, presence: true, numericality: true

end

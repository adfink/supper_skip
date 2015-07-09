class Category < ActiveRecord::Base
  has_many :category_items
  has_many :items, through: :category_items
  belongs_to :restaurant
  validates :name, presence: :true

  default_scope { order('position ASC')}
end

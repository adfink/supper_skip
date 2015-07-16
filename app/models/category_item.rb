class CategoryItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :category

  validates :item, presence: true
  validates :category, presence: true
end

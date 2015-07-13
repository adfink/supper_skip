class Item < ActiveRecord::Base
  belongs_to :restaurant
  has_many :order_items
  has_many :category_items
  has_many :categories, through: :category_items

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0}
  validates :status, inclusion: ['active', 'retired', 'Active', 'Retired']

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  default_scope { order('name ASC')}

  def self.active
    where(status: 'active')
  end

  def status=(new_status)
    super(new_status.downcase)
  end
end

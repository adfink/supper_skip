class Item < ActiveRecord::Base
  belongs_to :restaurant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :category_items
  has_many :categories, through: :category_items

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0}
  validate  :has_at_least_one_category

  validates :status, inclusion: ['active', 'retired', 'Active', 'Retired']

  has_attached_file :image, :styles => { :original => "300x300", :thumb => "100x100" }, :default_url => "default_image.jpg"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]



  default_scope { order('name ASC')}

  def self.active
    where(status: 'active')
  end

  def status=(new_status)
    super(new_status.downcase)
  end

  def self.new_item_plus_categories(params)
    if params[:categories]
      params[:categories].delete("0")
      params[:categories] = params[:categories].map do |category_id|
        Category.find(category_id.to_i)
      end
    end
    item = self.new(params)
    item
  end

  def update_item_plus_categories(params)
    if params[:categories]
      params[:categories].delete("0")
      params[:categories] = params[:categories].map do |category_id|
        Category.find(category_id.to_i)
      end
    end
    self.update(params)
  end


  private

  def has_at_least_one_category
    if categories.empty?
      errors.add(:categories, "Must have at least one assigned category")
    end
  end
end

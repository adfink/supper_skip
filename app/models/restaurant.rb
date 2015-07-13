class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :categories
  has_many :orders

  validates :name, presence: true, uniqueness: true
  validates :display_name, uniqueness: true

  def to_param
    format_display_name
  end

  def format_display_name
    display_name.downcase.gsub(" ", "-")
  end

  def create_display_name
    self.display_name = name.downcase.gsub(" ", "-")
  end

  def sanitize_display_name
    if display_name && display_name != ""
      self.display_name = format_display_name
    else
      create_display_name
    end
  end
end

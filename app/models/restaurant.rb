class Restaurant < ActiveRecord::Base
  validates :name, uniqueness: true,
                   presence: true
  validates :display_name, uniqueness: true

  belongs_to :user
  has_many :items
  has_many :categories
  has_many :orders

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

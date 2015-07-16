class OnlineOrder < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates_presence_of :user_id
end

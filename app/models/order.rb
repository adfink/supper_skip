class Order < ActiveRecord::Base
  include AASM

  validates :status, presence: true
  validates :user, presence: true
  validates :restaurant, presence: true
  validates :online_order, presence: true

  belongs_to :online_order
  belongs_to :restaurant
  belongs_to :user
  belongs_to :address
  has_many :order_items
  has_many :items, through: :order_items

  enum status: %w(ready_for_preparation cancelled in_preparation ready_for_delivery out_for_delivery completed)

  aasm :column => :status, :enum => true do
    state :ready_for_preparation, :initial => true
    state :cancelled
    state :in_preparation
    state :ready_for_delivery
    state :out_for_delivery
    state :completed

    event :prepare do
      transitions from: :ready_for_preparation, to: :in_preparation
    end

    event :cancel do
      transitions from: :ready_for_preparation, to: :cancelled
    end

    event :ready do
      transitions from: :in_preparation, to: :ready_for_delivery
    end

    event :deliver do
      transitions from: :ready_for_delivery, to: :out_for_delivery
    end

    event :complete do
      transitions from: :out_for_delivery, to: :completed
    end
  end

  def update_status(params)
    case params[:status]
      when 'prepare'
        self.prepare!
      when 'cancel'
        self.cancel!
      when 'ready'
        self.ready!
      when 'deliver'
        self.deliver!
      when 'complete'
        self.complete!
    end
  end

  def total
    order_items.map { |order_item| order_item.line_total }.reduce(:+)
  end

  def make_status_readable
    self.status.gsub("_", " ").capitalize
  end
end

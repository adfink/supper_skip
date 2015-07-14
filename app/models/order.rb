class Order < ActiveRecord::Base
  include AASM

  belongs_to :online_order
  belongs_to :restaurant
  belongs_to :user
  belongs_to :address
  has_many :order_items
  has_many :items, through: :order_items

  enum status: %w(ordered ready_for_preparation cancelled in_preparation ready_for_delivery out_for_delivery completed)

  aasm :column => :status, :enum => true do
    state :ordered, :initial => true
    state :ready_for_preparation
    state :cancelled
    state :in_preparation
    state :ready_for_delivery
    state :out_for_delivery
    state :completed

    event :pay do
      transitions from: :ordered, to: :ready_for_preparation
    end

    event :cancel do
      transitions from: [:ordered, :ready_for_preparation], to: :cancelled
    end

    event :prepare do
      transitions from: :ready_for_preparation, to: :in_preparation
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
      when 'pay'
        self.pay!
      when 'cancel'
        self.cancel!
      when 'prepare'
        self.prepare!
      when 'ready'
        self.ready!
      when 'deliver'
        self.deliver!
      when 'complete'
        self.complete!
    end
  end

  def subtotal
    line_totals = order_items.map { |order_item| order_item.line_total }
    line_totals.reduce(:+)
  end

  def tax
    subtotal * ".05".to_f
  end

  def total
    subtotal + tax
  end

  def make_status_readable
    self.status.gsub("_", " ").capitalize
  end
end

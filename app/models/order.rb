class Order < ActiveRecord::Base
  include AASM

  belongs_to :online_order
  belongs_to :restaurant
  belongs_to :user
  belongs_to :address
  has_many :order_items
  has_many :items, through: :order_items

  enum status: %w(ordered paid ready_for_preparation cancelled in_preparation out_for_delivery completed)

  aasm :column => :status, :enum => true do
    state :ordered, :initial => true
    state :paid
    state :ready_for_preparation
    state :cancelled
    state :in_preparation
    state :out_for_delivery
    state :ready_for_pickup
    state :completed

    event :pay do
      transitions from: :ordered, to: :paid
    end

    event :ready do
      transitions from: :paid, to: :ready_for_preparation
    end

    event :cancel do
      transitions from: [:ordered, :paid, :ready_for_preparation], to: :cancelled
    end

    event :prepare do
      transitions from: :ready_for_preparation, to: :in_preparation
    end

    event :deliver do
      transitions from: :in_preparation, to: :out_for_delivery
    end

    event :complete do
      transitions from: :out_for_delivery, to: :completed
    end
  end

  def update_status(params)
    case params[:status]
      when 'pay'
        self.pay!
      when 'ready'
        self.ready!
      when 'cancel'
        self.cancel!
      when 'prepare'
        self.prepare!
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
end

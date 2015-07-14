class OrderCreator
  def initialize(cart_items, online_order, address)
    @cart_items = cart_items
    @online_order = online_order
    @address = address
  end

  def create_restaurant_orders
    items_grouped_by_restaurant_id.each do |restaurant_id, items_and_quantity|
      order = make_order(restaurant_id)
      make_order_items(order, items_and_quantity)
    end
  end

  def items_grouped_by_restaurant_id
    items_hash = {}

    @cart_items.each do |item_id, quantity|
      item = Item.find(item_id.to_i)
      if items_hash[item.restaurant_id].nil?
        items_hash[item.restaurant_id] = [[item.id, quantity]]
      else
        items_hash[item.restaurant_id] << [item.id, quantity]
      end
    end
    items_hash
  end

  def make_order(restaurant_id)
    Order.create(user_id: @online_order.user_id,
      online_order_id: @online_order.id,
      restaurant_id: restaurant_id,
      address_id: @address)
  end

  def make_order_items(order, items_and_quantity)
    items_and_quantity.each do |item_id, quantity|
      order.order_items.create(item_id: item_id, quantity: quantity)
    end
  end
end

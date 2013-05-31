class Cart
  include Mongoid::Document
  # include Mongoid::Timestamps::Created
  # include Mongoid::Timestamps::Updated
  include Mongoid::Timestamps::Short

  has_many :line_items, :dependent => :destroy, :autosave => true


  def total_price
    line_items.sum(&:total_price)
  end

  def add_product(product_id, price)
    current_item = line_items.where(:product_id => product_id).first_or_initialize(:price => price, :quantity => 0)
    current_item.quantity += 1
    current_item
  end
end
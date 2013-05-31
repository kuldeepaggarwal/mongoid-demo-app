class Order
  include Mongoid::Document
  # include Mongoid::Timestamps::Created
  # include Mongoid::Timestamps::Updated
  include Mongoid::Timestamps::Short
  PAYMENT_TYPES = { "Check" => 0, "Credit Card" => 1, "Purchase Order" => 2 }

  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :address, type: String
  field :email, type: String
  field :tm, as: :total_amount, type: Float
  field :pay_type, type: Integer

  has_many :line_items, :dependent => :destroy, :autosave => true

  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item| 
      line_item.cart_id = nil
      self.line_items << line_item
    end
  end
end
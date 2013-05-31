class LineItem
  include Mongoid::Document
  # include Mongoid::Timestamps::Created
  # include Mongoid::Timestamps::Updated
  include Mongoid::Timestamps::Short

  field :quantity, type: Integer
  field :price, type: Float

  belongs_to :cart
  belongs_to :product
  belongs_to :order

  def total_price
    product.price * quantity
  end
end
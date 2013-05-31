class Product
  include Mongoid::Document
  # include Mongoid::Timestamps::Created
  # include Mongoid::Timestamps::Updated
  include Mongoid::Timestamps::Short

  field :title, type: String
  field :description, type: String
  field :image_url, type: String
  field :price, type: Float

  has_many :line_items, :dependent => :restrict
  has_and_belongs_to_many :orders#, through: :line_items

  scope :order, ->(column) { order_by(column => :desc) }
end
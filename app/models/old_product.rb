class OldProduct < ActiveRecord::Base
  include MongoidBridge

  self.table_name = "products"

  has_one_document :product
end

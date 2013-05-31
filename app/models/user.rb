# MongoDB types

# Array
# BigDecimal
# Boolean
# Date
# DateTime
# Float
# Hash
# Integer
# Moped::BSON::ObjectId
# Moped::BSON::Binary
# Range
# Regexp
# String
# Symbol
# Time
# TimeWithZone
class User
  include Mongoid::Document
  # include Mongoid::Timestamps::Created
  # include Mongoid::Timestamps::Updated
  include Mongoid::Timestamps::Short

  field :uname, as: :username, type: String
  field :fn,    as: :first_name, type: String
  field :ln,    as: :last_name,  type: String
  field :password,   type: ::Mongoid::EncryptedString

  def authenticate!(password)
    self.password == password
  end
end
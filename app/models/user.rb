class User < ApplicationRecord
  has_many :books
  has_secure_token

  validates :email, :password, presence:true
  validates :email, uniqueness:{ case_sensitive: false }
  validates :password, length:{ minimum: 6 }

  before_save { self.email = email.downcase }
end

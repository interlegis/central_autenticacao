class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  attr_accessor :skip_password, :uid
  validates :password, length: { minimum: 8 }, unless: :skip_password
  validates :password, confirmation: true
  validates :email, uniqueness: true
  def name
    user.first_name + ' ' + user.last_name
  end
end

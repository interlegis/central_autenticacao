class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  has_one :api_accesses, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  attr_accessor :skip_password, :uid
  validates :password, length: { minimum: 8 }, unless: :skip_password
  validates :password, confirmation: true
  validates :email, uniqueness: true
  has_one_attached :avatar
  def name
    self.first_name + ' ' + self.last_name
  end
end

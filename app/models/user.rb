class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  has_one :api_access, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  attr_accessor :skip_password, :skip_avatar,:uid
  validates :password, length: { minimum: 8 }, unless: :skip_password
  validates :password, confirmation: true
  validates :email, uniqueness: true
  validates :cpf, length: { is: 14 }, uniqueness: true
  validates :avatar, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg']}, unless: :skip_avatar
  before_save :capitalize_name
  has_one_attached :avatar
  belongs_to :role
  # TODO adicionar validação de data

  def name
    self.first_name + ' ' + self.last_name
  end

  def capitalize_name
    self.first_name=self.first_name.split.map(&:capitalize).join(' ')
    if self.last_name.present?
      self.last_name=self.last_name.split.map(&:capitalize).join(' ')
    else
      self.last_name = self.first_name.split[1..-1].join(' ')
      self.first_name = self.first_name.split[0]
    end
    if !self.role_id.present?
      self.role_id = 2
    end
  end

  def complete?
    self.cpf.present? and self.birth_date.present? and self.cep.present? and self.address.present? and self.addr_number.present? and self.city.present? and self.state.present?
  end

end

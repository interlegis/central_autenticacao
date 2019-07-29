class ApiAccessesLevel < ApplicationRecord
  has_many :api_accesses, :dependent => :destroy
end

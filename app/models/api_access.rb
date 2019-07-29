class ApiAccess < ApplicationRecord
  belongs_to :user
  belongs_to :api_accesses_level
end

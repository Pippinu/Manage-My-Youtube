class Affiliation < ApplicationRecord
    validates :manager, presence: true
  validates :cliente, presence: true
end

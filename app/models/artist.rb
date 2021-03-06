class Artist < ApplicationRecord
    self.primary_key = :id
    has_many :albums, dependent: :destroy
    has_many :tracks, through: :albums
end

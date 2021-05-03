class Album < ApplicationRecord
    self.primary_key = :id
    belongs_to :artist
    has_many :tracks
end

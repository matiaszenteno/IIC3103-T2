class Track < ApplicationRecord
    self.primary_key = :id
    belongs_to :album
end

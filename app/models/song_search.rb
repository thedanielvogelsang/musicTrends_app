class SongSearch < ApplicationRecord
  belongs_to :song
  belongs_to :search
end

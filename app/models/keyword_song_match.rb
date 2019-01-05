class KeywordSongMatch < ApplicationRecord
  belongs_to :keyword
  belongs_to :song

  validates_presence_of :count

  def self.search_and_add(k_id, s_id)
    kws = KeywordSongMatch.find_or_create_by(keyword_id: k_id, song_id: s_id)
    kws.id ? kws.update(count: (kws.count + 1)) : kws.update(count: 1)
  end

end

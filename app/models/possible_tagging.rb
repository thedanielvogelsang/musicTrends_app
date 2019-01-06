class PossibleTagging < ApplicationRecord
  belongs_to :song
  belongs_to :tag

  def self.add_or_create_tagging(s_id, t_id)
    pstg = PossibleTagging.find_or_create_by(song_id: s_id, tag_id: t_id)
    pstg.count ? pstg.update(count: pstg.count + 1) : pstg.update(count: 1)
  end

end

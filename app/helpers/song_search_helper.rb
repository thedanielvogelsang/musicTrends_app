module SongSearchHelper
  def sync_song_and_search(song_id, search_id)
    ss = SongSearch.find_or_create_by(song_id: song_id, search_id: search_id)
    new_ct = ss.count.to_i + 1
    ss.update(count: new_ct)
  end
end

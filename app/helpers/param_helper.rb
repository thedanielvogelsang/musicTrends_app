module ParamHelper

  def safe_song(song)
    if song
      if song[:album] && song[:album][:artist]
        aname = song[:album][:artist][:name]
        a_id = song[:album][:artist][:id]
      end
      return {
          id: params[:song_id],
          title: song[:full_title],
          artist_name: aname || "unknown",
          artist_id: a_id || 0,
          annotation_ct: song[:annotation_count]
        }
    end
  end

  def safe_search
    if params[:search]
      return {
        text: params[:search][:text],
        search_type: "Song"
      }
    end
  end

end

module ParamHelper

  def safe_song(song)
    if song
      if song[:album] && song[:album][:artist]
        aname = song[:album][:artist][:name]
        a_id = song[:album][:artist][:id]
      end
      if song[:title] && song[:full_title]
        title = song[:full_title]
      else
        title = song[:title]
      end
      return {
          id: song[:id],
          title: title,
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

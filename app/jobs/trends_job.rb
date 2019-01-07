class TrendsJob
  include Sidekiq::Worker

  def perform(type, id)
    case type
    when "Song"
      # TrendService.find_and_store_song_trends(trends_log)
    when "Tag"
      # TrendService.find_and_store_tag_trends(trends_log)
    end
  end
end

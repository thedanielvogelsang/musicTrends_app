class TrendsJob
  include Sidekiq::Worker

  def perform(type, trends)
    case type
    when "Song"
      # TrendService.new(type, trends).log_song_trends(trends)
    when "Tag"
      # TrendService.find_and_store_tag_trends(trends)
    when "Search"
      # TrendService.find_and_store_search_trends(trends)
    end
  end
end

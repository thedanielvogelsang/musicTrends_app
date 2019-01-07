class TrendsJob
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(type, trends)
    case type
    when "Song"
      TrendService.new(type, trends).log_song_trends
    when "Tag"
      TrendService.new(type, trends).log_tag_trends
    when "Search"
      # TrendService.find_and_store_search_trends(trends)
    end
  end
end

class TagJob
  include Sidekiq::Worker

  def perform(id)
    tw = TagWorker.new(id)
    tw.match_likely_songs_and_find_trends
  end

end

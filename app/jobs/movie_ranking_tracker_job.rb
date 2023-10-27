class MovieRankingTrackerJob < ActiveJob::Base
  queue_as :default

  def perform
    Movies::RankingTracker.call
  end
end

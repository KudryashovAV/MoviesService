module Movies
  class RankingTracker < RankingBase
    def self.call
      new.call
    end

    def call
      clear_all_records
      user_ids = fetch_user_ids
      movie_rankings = []

      user_ids.each do |user_id|
        movie_rankings << fetch_from_api_service(user_id).each { |record| record["user_id"] = user_id }
      end

      populate_data(movie_rankings.flatten)
    end

    private

    def clear_all_records
      MovieRanking.delete_all
    end

    def fetch_user_ids
      User.pluck(:id)
    end
  end
end

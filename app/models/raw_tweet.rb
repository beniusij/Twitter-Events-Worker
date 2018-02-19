class RawTweet < ApplicationRecord
  validates :tweet_id, presence: true, uniqueness: true
  validates :full_text, :uri, presence: true
end

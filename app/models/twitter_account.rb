class TwitterAccount < ApplicationRecord
  validates :twitter_name, presence: true, uniqueness: true
end

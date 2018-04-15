class TwitterAccount < ApplicationRecord
  validates :twitter_name, presence: true, uniqueness: true

  # Get least checked accounts
  def self.least_checked(num)
    TwitterAccount.order(last_checked: :asc).limit(num)
  end
end

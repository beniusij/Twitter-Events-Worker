class TwitterAccount < ApplicationRecord
  validates :twitter_name, presence: true, uniqueness: true

  # Get least checked accounts
  def self.least_checked(num)
    TwitterAccount.order(last_checked: :asc).limit(num)
  end

  def self.add_account(username)
    TwitterAccount.create do |t|
      t.twitter_name = username
      t.last_checked = Time.now - 1.day
    end
  end
end

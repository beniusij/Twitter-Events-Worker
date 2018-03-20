class Event < ApplicationRecord
  validates :date, :keywords, presence: true

  def self.delete_old_events
    where("date < ?", Date.today).delete_all
  end
end

class Event < ApplicationRecord
  validates :date, :keywords, presence: true
end

class Failure < ApplicationRecord
  validates :text, presence: true

  def self.save_case(text, error)
    Failure.create do |t|
      t.text  = text
      t.error = error
    end
  end
end

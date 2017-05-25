class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendees
  has_many :messages
end

class Band < ApplicationRecord
  belongs_to :user
  has_many :pictures
  has_many :bookings

  has_many :host_reviews

  has_many :band_musics, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :band_type, presence: true
  validates :band_name, presence: true
  validates :band_genre, presence: true
  validates :band_sec_genre, presence: true

  def cover_picture(size)
    if !pictures.empty?
      pictures[0].image.url(size)
    else
      ActionController::Base.helpers.asset_url 'blank.jpg'
    end
  end

  def average_rating
    host_reviews.count.zero? ? 0 : host_reviews.average(:star).round(2).to_i
  end
end

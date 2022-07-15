class Venue < ApplicationRecord
  enum instant: { Request: 0, Instant: 1 }

  belongs_to :user
  has_many :photos
  has_many :bookings

  has_many :guest_reviews
  has_many :calendars

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :venue_type, presence: true
  validates :gig_type, presence: true
  validates :capacity, presence: true

  def cover_photo(size)
    if !photos.empty?
      photos[0].image.url(size)
    else
      'blank.jpg'
    end
  end

  def average_rating
    guest_reviews.count.zero? ? 0 : guest_reviews.average(:star).round(2).to_i
  end

  def as_json(*args)
    # {
    #     id: id,
    #     latitude: venue.latitude,
    #     longitude: venue.longitude,
    #     payout: payout,
    #     listing_name: venue.listing_name,
    #
    # }
    {
        type: "Feature",
        geometry: {
            type: "Point",
            coordinates: [latitude.to_f, longitude.to_f]
        },
        properties: {
            id: id,
            name: listing_name,
            about: listing_name,
            logo:	cover_photo(nil),
            image:	cover_photo(nil),
            link:	"/venues/#{id}",
            stars:	average_rating,
            price:	payout
        }
    }
  end

end

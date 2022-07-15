class Booking < ApplicationRecord
  enum status: { Waiting: 0, Approved: 1, Declined: 2 }

  after_create_commit :create_notification

  belongs_to :band
  belongs_to :venue

  def cover_photo(size)
    if !@venue.photos.empty?
      @venue.photos[0].image.url(size)
    else
      'blank.jpg'
    end
  end

  def cover_picture(size)
    if !@band.pictures.empty?
      @band.pictures[0].image.url(size)
    else
      'blank.jpg'
    end
  end

  def approved_bookings
    where(status: 1)
  end

  scope :current_week_revenue, ->(user) {
    joins(:band)
      .where('bands.user_id = ? AND bookings.updated_at >= ? AND bookings.status = ?', user.id, 1.week.ago, 1)
      .order(updated_at: :asc)
  }

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
            coordinates: [venue.latitude.to_f, venue.longitude.to_f]
        },
        properties: {
            id: id,
            name: venue.listing_name,
            about: venue.listing_name,
            logo:	venue.cover_photo(nil),
            image:	venue.cover_photo(nil),
            link:	"/bookings/#{id}",
            stars:	band.average_rating,
            price:	payout,
            start: date,
            end: date
        }
    }
  end



  private

  def create_notification
    type = venue.Instant? ? 'New Booking' : 'New Request'
    guest = User.find(band.user_id)

    Notification.create(content: "#{type} from #{guest.fullname}", user_id: venue.user_id)
  end

end

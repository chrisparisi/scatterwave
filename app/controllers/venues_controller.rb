class VenuesController < ApplicationController
  before_action :set_venue, except: %i[index new create published]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: %i[listing payout description photo_upload genre location update]

  def index
    @venues = current_user.venues
  end

  def new
    # return redirect_to payment_method_path, alert: 'Please add to payment\'s details first, Don\'t worry We will not charge right now.' unless current_user.stripe_id
    current_user.update(account_type: "Venue")
    @venue = current_user.venues.build
  end

  def create
    @venue = current_user.venues.build(venue_params)
    if @venue.save
      redirect_to payout_venue_path(@venue), notice: 'Saved...'
    else
      flash[:alert] = 'Something went wrong...'
      render :new
    end
  end

  def show
    @photos = @venue.photos
    @guest_reviews = @venue.guest_reviews
    @future_shows = @venue.bookings.Approved.where("date >= ?", Time.now)
  end

  def listing; end

  def payout; end

  def description; end

  def photo_upload
    @photos = @venue.photos
  end

  # def genre; end

  def published; end

  def update
    new_params = venue_params
    new_params = venue_params.merge(active: true) if is_ready_venue && current_user.merchant_id.present?

    if @venue.update(new_params)
      flash[:notice] = 'Saved...'
      redirect_to next_step
      # return redirect_to payment_method_path, alert: 'Please add to payment\'s details first, Don\'t worry We will not charge right now.' unless current_user.stripe_id
    else
      flash[:alert] = 'Something went wrong...'
    end
    #redirect_back(fallback_location: request.referer)
  end

  #-- Bookings
  def preload
    today = Date.today
    bookings = @venue.bookings.where('date >= ?', today)
    available_dates = @venue.calendars.joins(:calendar_times).where('status = ? AND day > ?', 0, today)

    render json: {
      bookings: bookings,
      available_dates: available_dates
    }
  end

  def preview
    calendar_time = CalendarTime.find(params[:calendar_time_id])
    booking = Booking.Approved.where(calendar_time_id: params[:calendar_time_id]).first
    if calendar_time.present? && booking.blank?
      output = { conflict: false, price: calendar_time.calendar.payout }
    else
      output = { conflict: true}
    end
    render json: output
  end

  def get_available_times
    date = Date.parse(params[:start_date])
    day_avalibility = @venue.calendars.where("(? <= day AND day <= ?) AND status = ?", date.beginning_of_day, date.end_of_day,  0).first
    @times = day_avalibility.calendar_times.joins("LEFT JOIN bookings ON bookings.calendar_time_id = calendar_times.id AND bookings.status = 1").where("bookings.id IS NULL")
  end

  # def preview
  #   date = Date.parse(params[:date])
  #   start_time = Date.parse(params[:start_time])
  #   end_time = Date.parse(params[:end_time])
  #
  #
  # end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def is_authorized
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @venue.user_id
  end

  def is_ready_venue
    !@venue.active && @venue.payout.present? && @venue.listing_name.present? && @venue.photos.present? && @venue.address.present?
  end

  def venue_params
    params.require(:venue).permit(:venue_type, :gig_type, :capacity, :listing_name, :summary, :comments, :address, :is_alternative, :is_americana, :is_blues, :is_christian,
                                  :is_classical, :is_comedy, :is_country, :is_edm, :is_electronic, :is_folk, :is_hiphop, :is_jazz, :is_latin, :is_metal, :is_pop,
                                  :is_rb, :is_rock, :is_spokenword, :is_world, :payout, :active, :instant, :longitude, :latitude)
  end

  def next_step
    if params[:venue][:venue_type].present?
      payout_venue_path
    elsif params[:venue][:payout].present?
      description_venue_path
    elsif params[:venue][:listing_name].present?
      photo_upload_venue_path
    elsif params[:venue][:images].present?
      genre_venue_path
    elsif params[:is_genre].present?
      published_venues_path
    elsif params[:venue][:active].present? && params[:venue][:active] == "false"
      payment_method_path(payout_tab: true)
    else
      published_venues_path
    end
  end

end

class PagesController < ApplicationController
  def home
    @bands = Band.where(active: true).order('RANDOM()')
    @venues = Venue.where(active: true).order('RANDOM()')
    @bookings = Booking.where(status: 1).order('RANDOM()')
  end

  def search
    if params[:category] == "shows"
      redirect_to search_shows_path(search: {name: params[:search][:name], location: params[:search][:location]})
    elsif params[:category] == "bands"
      redirect_to search_bands_path(search: {name: params[:search][:name], location: params[:search][:location]})
    elsif params[:category] == "venues"
      redirect_to search_venues_path(search: {name: params[:search][:name], location: params[:search][:location]})
    end
  end

  def search_bands
    # # STEP 1
    # session[:loc_search] = params[:search_bands] if params[:search_bands].present? && params[:search_bands].strip != ''
    #
    # # STEP 2
    # if session[:loc_search] && session[:loc_search] != ''
    #   @bands_address = Band.where(active: true).near(session[:loc_search], 5, order: 'distance')
    # else
    #   @bands_address = Band.where(active: true).all
    # end
    #
    # # STEP 3
    # @search_bands = @bands_address.ransack(params[:q])
    # @bands = @search_bands.result

    @search = Searches::BandSearch.new(params[:search])
    @arrBands = @search.results
  end

  def search_shows
    # # STEP 1
    # if params[:search_shows].present? && params[:search_shows].strip != ""
    #   session[:loc_search] = params[:search_shows]
    # end
    #
    # # STEP 2
    # if session[:loc_search] && session[:loc_search] != ""
    #   # venues = Venue.near(session[:loc_search], 5, order: 'distance').where(active: true)
    #   venues = Venue.where(active: true).all
    # else
    #   venues = Venue.where(active: true).all
    # end
    #
    # # STEP 3
    # @venue_shows = venues.ransack(params[:q])
    # shows = @venue_shows.result
    #
    # if params[:s_date].present? || params[:e_date].present?
    #   sdate = Date.parse(params[:s_date]) if params[:s_date]
    #   edate = Date.parse(params[:e_date]) if params[:e_date]
    #   sdate = edate if sdate.blank?
    #   edate = sdate if edate.blank?
    #
    #   @arrBookings = Booking.Approved.includes(:venue).references(:venue).merge(shows).where("? <= date AND date <= ?", sdate, edate)
    # else
    #   @arrBookings = Booking.Approved.includes(:venue).references(:venue).merge(shows)
    # end

    @search = Searches::ShowSearch.new(params[:search])
    @arrBookings = @search.results
  end

  def search_venues
    # # STEP 1
    # session[:loc_search] = params[:search_venues] if params[:search_venues].present? && params[:search_venues].strip != ''
    #
    # # STEP 2
    # if session[:loc_search] && session[:loc_search] != ''
    #   @venues_address = Venue.where(active: true).near(session[:loc_search], 5, order: 'distance')
    # else
    #   @venues_address = Venue.where(active: true).all
    # end
    #
    # # STEP 3
    # @search_venues = @venues_address.ransack(params[:q])
    # @venues = @search_venues.result
    #
    # @arrVenues = @venues.to_a
    #
    # # STEP 4
    # if params[:date].present?
    #
    #   date = Date.parse(params[:date])
    #
    #   @venues.each do |venue|
    #     not_available = venue.bookings.where(
    #       "(? <= date AND date <= ?)
    #       OR (date < ?)",
    #       date, date,
    #       date
    #     ).limit(1)
    #
    #     not_available_in_calendar = venue.calendars.where(
    #       'status = ? AND ? <= day AND day <= ?',
    #       1, date, date
    #     ).limit(1)
    #
    #     @arrVenues.delete(venue) if !not_available.empty? || !not_available_in_calendar.empty?
    #   end
    # end

    @search = Searches::VenueSearch.new(params[:search])
    @arrVenues = @search.results

  end

  def switch_accounts
    current_user.update(account_type: current_user.account_type == "Venue" ? "Band" : "Venue")
    redirect_to dashboard_path
  end

  def contact
    if params[:email]
      flash[:notice] = "your message has been sent."
      PageMailer.contact_us_admin(params[:name], params[:surname], params[:email], params[:message]).deliver!
      PageMailer.contact_us_user(params[:name], params[:email]).deliver!
    end
    redirect_to contact_us_path
  end
end

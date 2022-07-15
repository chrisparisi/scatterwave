class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper

  def create
    date_from = Date.parse(calendar_params[:start_date])
    date_to = Date.parse(calendar_params[:end_date])

    (date_from..date_to).each do |date|
      calendar = Calendar.where(venue_id: params[:venue_id], day: date, )

      if calendar.present?
        calendar.update_all(payout: calendar_params[:payout], status: calendar_params[:status])
      else
        Calendar.create(
          {venue_id: params[:venue_id],
          day: date,
          payout: calendar_params[:payout],
          status: calendar_params[:status]}.merge(calendar_params[:calendar_times_attributes].present? ? {calendar_times_attributes: calendar_params[:calendar_times_attributes]} : {})
        )
      end
    end

    redirect_to host_calendar_path
  end

  def host
    @calendar = Calendar.new
    @venues = current_user.venues

    if @venues.blank?
      redirect_to venues_path
      flash[:alert] = 'You must create a venue first before you can make a calendar for it!'
    end

    params[:date] ||= Date.current.to_s
    params[:venue_id] ||= @venues[0] ? @venues[0].id : nil

    if params[:q].present?
      params[:date] = params[:q][:date]
      params[:venue_id] = params[:q][:venue_id]
    end

    @search = Booking.ransack(params[:q])

    if params[:venue_id]
      @venue = Venue.find(params[:venue_id])
      date = Date.parse(params[:date])

      first_of_month = (date - 3.months).beginning_of_month # => Jun 1
      end_of_month = (date + 6.months).end_of_month # => Aug 31

      @events = @venue.bookings.joins(:band)
                      .select('bookings.*, bands.band_name')
                      .where('(date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
      @days = Calendar.where('venue_id = ? AND day BETWEEN ? AND ?', params[:venue_id], first_of_month, end_of_month)
    else
      @venue = nil
      @events = []
      @days = []
    end
  end

  def guest
    @calendar = Calendar.new
    @band = current_user.band

    if @band.blank?
      redirect_to bands_path
      flash[:alert] = 'You must create a band first before you can make a calendar for it!'
    else
      params[:date] ||= Date.current.to_s
      params[:band_id] ||= @band[0] ? @band[0].id : nil
    end

    if params[:band_id]
      @band = Band.find(params[:band_id])
      date = Date.parse(params[:date])

      first_of_month = (date - 3.months).beginning_of_month # => months before
      end_of_month = (date + 6.months).end_of_month # => months ahead

      @events = @bands.bookings.joins(:venue)
                      .select('bookings.*, venues.listing_name')
                      .where('(date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)
    else
      @band = nil
      @events = []
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    @venue = @calendar.venue
  end

  def update
    @calendar = Calendar.find(params[:id])
    @calendar.update(payout: calendar_params[:payout], status: calendar_params[:status], calendar_times_attributes: calendar_params[:calendar_times_attributes])
    redirect_to host_calendar_path
  end

  private

  def calendar_params
    params.require(:calendar).permit(:payout, :status, :start_date, :end_date, calendar_times_attributes: [:id, :start_time, :end_time, :_destroy])
  end
end

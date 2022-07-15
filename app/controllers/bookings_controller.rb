class BookingsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_booking, only: %i[approve decline show send_pay_request mark_paid]
  before_action :set_views, only: [:show]

  def create
    venue = Venue.find(params[:venue_id])

    if !venue.active
      flash[:alert] = 'venue not active.'
      return redirect_to root_path
    elsif venue.user.stripe_id.blank?
      flash[:alert] = 'venue not verified their payment method.'
      return redirect_to root_path
    elsif current_user.merchant_id.blank?
      flash[:alert] = 'Please update your payout method.'
      return redirect_to payout_method_path
    else
      calendar_time = CalendarTime.find(params[:calendar_time_id])
      booking = Booking.Approved.where(calendar_time_id: params[:calendar_time_id]).first

      if calendar_time.present? && booking.blank?
        params[:booking][:start_time] = calendar_time.start_time
        params[:booking][:end_time] = calendar_time.end_time

        @booking = current_user.band.bookings.build(booking_params.merge(calendar_time_id: calendar_time.id))
        @booking.venue = venue
        @booking.payout = calendar_time.calendar.payout ||= venue.payout
        # @booking.save

        if @booking.Waiting!
          # if venue.Request?
          flash[:notice] = 'Request sent successfully!'
          BookingMailer.send_email_booking_request_to_band(@booking).deliver! if @booking.band.user.setting.enable_email
          BookingMailer.send_email_booking_request_to_venue(@booking).deliver! if @booking.venue.user.setting.enable_email

          send_sms(@booking.band.user.phone_number, "you requested to book a gig at #{@booking.venue.listing_name} on #{@booking.date.strftime('%d %b, %Y')} at #{@booking.start_time.strftime('%I:%M %p')}-#{@booking.end_time.strftime('%I:%M %p')}. Check them out and book them on Scatterwave!") if @booking.band.user.setting.enable_email
          send_sms(@booking.venue.user.phone_number, "#{@booking.band.band_name} has requested to book a gig at #{@booking.venue.listing_name} on #{@booking.date.strftime('%d %b, %Y')} at #{@booking.start_time.strftime('%I:%M %p')}-#{@booking.end_time.strftime('%I:%M %p')}. Check them out and book them on Scatterwave!") if @booking.venue.user.setting.enable_email

          # else
            # charge(venue, @booking)
            # set_approve_booking(venue, @booking)
          # end
        else
          flash[:alert] = 'Cannot make a booking!'
        end

      else
        flash[:alert] = 'Booking dates are not available.'
        return redirect_to payout_method_path
      end



      # check_valid =  is_conflict(date, start_time, end_time, venue)
      # if check_valid[:conflict]
      #   flash[:alert] = 'Booking dates are not available.'
      #   return redirect_to payout_method_path
      # else
      #   @booking = current_user.band.bookings.build(booking_params)
      #   @booking.venue = venue
      #   @booking.payout = check_valid[:price] ||= venue.payout
      #   # @booking.save
      #
      #   if @booking.Waiting!
      #     if venue.Request?
      #       flash[:notice] = 'Request sent successfully!'
      #     else
      #       # charge(venue, @booking)
      #       set_approve_booking(venue, @booking)
      #     end
      #   else
      #     flash[:alert] = 'Cannot make a booking!'
      #   end
      # end
    end
    redirect_to venue
  end

  def your_tours
    @tours = (current_user.band.bookings.order(date: :desc).paginate(page: params[:page], per_page: 10) if current_user.band.present?)
  end

  def your_bookings
    # @venues = current_user.venues
    @bookings = Booking.joins(:venue).where(venues: {user_id: current_user.id}).order(date: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    @musics = @booking.band.band_musics
  end

  def approve
    # charge(@booking.venue, @booking)
    set_approve_booking(@booking.venue, @booking)
    redirect_to your_bookings_path
  end

  def decline
    @booking.Declined!
    redirect_to your_bookings_path
  end

  def send_pay_request
    if current_user.id == @booking.band.user_id
      Notification.create(content: "New payment Request from #{current_user.fullname} for booking", user_id: @booking.venue.user_id)
      BookingMailer.send_payment_request(current_user, @booking.venue.user).deliver!
      @booking.update_attributes(request_count: @booking.request_count + 1, request_sent_at: Time.now)
      flash[:notice] = 'Payment request sent successfully..'
      redirect_to your_tours_path
    else
      flash[:alert] = 'You are not authorise to sent pay request.'
      redirect_to root_path
    end
  end

  def mark_paid
    if current_user.id == @booking.venue.user_id
      charge(@booking.venue, @booking)
      redirect_to your_bookings_path
    else
      flash[:alert] = 'You are not authorise to mark as paid.'
      redirect_to root_path
    end
  end

  private

  def send_sms(to, msg)
    begin
      @client = Twilio::REST::Client.new
      @client.messages.create(
        from: '8053605998',
        to: to,
        body: msg
      )
    rescue => e
      Rails.logger.info "Sending message error: "+ e.message
    end
  end

  def charge(venue, booking)
    if booking.band.user.stripe_id.present?
      customer = Stripe::Customer.retrieve(booking.venue.user.stripe_id)
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: booking.payout * 100,
        description: booking.band.band_name,
        currency: 'usd',
        destination: {
          amount: booking.payout * 91, # 91% of the total amount goes to the host
          account: booking.band.user.merchant_id # Band's stripe customer ID
        }
      )

      if charge
        booking.update_attributes(is_paid: true, paid_at: Time.now)
        # BookingMailer.send_email_to_guest(booking.band.user, venue).deliver_later if booking.band.user.setting.enable_email
        # send_sms(venue, booking) if venue.user.setting.enable_sms
        BookingMailer.send_email_booking_paid_to_band(booking).deliver! if booking.band.user.setting.enable_email
        send_sms(booking.band.user.phone_number, "Your payment for your performance has been sent to your stripe account for the amount of $#{(booking.payout * 91)/100.00}!") if booking.band.user.setting.enable_email

        flash[:notice] = 'Booking payment successfully!'
      else
        # booking.Declined!
        flash[:alert] = 'Cannot charge with this payment method!'
      end
    end
  rescue Stripe::CardError => e
    booking.declined!
    flash[:alert] = e.message
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_views; end

  def booking_params
    params.require(:booking).permit(:date, :start_time, :end_time)
  end

  def set_approve_booking(venue, booking)
    booking.Approved!
    # BookingMailer.send_email_to_guest(booking.band.user, venue).deliver_later if booking.band.user.setting.enable_email
    # send_sms(venue, booking) if venue.user.setting.enable_sms

    BookingMailer.send_email_booking_approve_to_band(@booking).deliver! if @booking.band.user.setting.enable_email
    send_sms(@booking.band.user.phone_number, "Congratulations! You got yourself a gig at #{ @booking.venue.listing_name } on #{ @booking.date.strftime('%d %b, %Y') } at #{ @booking.start_time.strftime('%I:%M %p') }-#{ @booking.end_time.strftime('%I:%M %p') }! Check out your booking at scatterwave or message the band through Scatterwave to get more details!") if @booking.band.user.setting.enable_email

    flash[:notice] = 'Booking created successfully!'
  end

  def is_conflict(date, start_time, end_time, venue)
    conflict = true
    day_avalibility = venue.calendars.where("(? <= day AND day <= ?) AND status = ?", date.beginning_of_day, date.end_of_day,  0).first
    if date > Time.now && day_avalibility.present?
      bookings = venue.bookings.where("(? <= date AND date <= ?) AND (( ? <  start_time::time AND start_time::time < ? ) OR ( ? < end_time::time AND end_time::time < ? )) AND status = ?", date.beginning_of_day, date.end_of_day, start_time.strftime("%k:%M:%S"), end_time.strftime("%k:%M:%S"), start_time.strftime("%k:%M:%S"), end_time.strftime("%k:%M:%S"), 1)
      unless bookings.present?
        if day_avalibility.calendar_times.present?
          times = day_avalibility.calendar_times.where("(( ? <=  end_time::time AND start_time::time <= ? ) AND ( ? <= end_time::time AND start_time::time <= ? ))", start_time.strftime("%k:%M:%S"), start_time.strftime("%k:%M:%S"), end_time.strftime("%k:%M:%S"), end_time.strftime("%k:%M:%S"))
          if times.present?
            conflict = false
          end
        else
          conflict = false
        end
      end
    end
    conflict ? { conflict: true } : { conflict: false, price: day_avalibility.payout }
  end

end

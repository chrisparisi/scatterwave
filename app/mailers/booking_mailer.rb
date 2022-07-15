class BookingMailer < ApplicationMailer
  def send_email_to_guest(guest, venue)
    @recipient = guest
    @venue = venue
    mail(to: @recipient.email, subject: 'Put on a great show!')
  end

  # Booking Request Approved
  def send_email_booking_approve_to_band(booking)
    @booking = booking
    mail(to: booking.band.user.email, subject: 'Congratulations! you have a great show!')
  end

  # Booking Request occur
  def send_email_booking_request_to_band(booking)
    @booking = booking
    mail(to: booking.band.user.email, subject: 'Your booking request submitted!')
  end

  def send_email_booking_request_to_venue(booking)
    @booking = booking
    mail(to: booking.venue.user.email, subject: 'Your have got new request submitted!')
  end

  # Booking got paid
  def send_email_booking_paid_to_band(booking)
    @booking = booking
    mail(to: booking.band.user.email, subject: 'Booking Paid!')
  end


  def send_payment_request(me, venue_user)
    @user = me
    @venue_user = venue_user
    mail(to: venue_user.email, subject: 'Payment request for booking!')
  end
end

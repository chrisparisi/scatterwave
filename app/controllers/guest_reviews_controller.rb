class GuestReviewsController < ApplicationController
  def create
    # Step 1: Check if the booking exist (room_id, host_id, host_id)

    # Step 2: Check if the current host already reviewed the guest in this booking.

    @booking = Booking.where(
      id: guest_review_params[:booking_id],
      venue_id: guest_review_params[:venue_id],
      band_id: guest_review_params[:band_id]
    ).first

    if !@booking.nil? && @booking.venue.user.id == guest_review_params[:host_id].to_i

      @has_reviewed = GuestReview.where(
        booking_id: @booking.id,
        host_id: guest_review_params[:host_id]
      ).first

      if @has_reviewed.nil?
        # Allow to review
        @guest_review = current_user.guest_reviews.create(guest_review_params)
        flash[:success] = 'Review created...'
      else
        # Already reviewed
        flash[:success] = 'You already reviewed this booking'
      end
    else
      flash[:alert] = "Haven't found this booking"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy

    redirect_back(fallback_location: request.referer, notice: 'Removed...!')
  end

  private

  def guest_review_params
    params.require(:guest_review).permit(:comment, :star, :venue_id, :band_id, :booking_id, :host_id)
  end
end

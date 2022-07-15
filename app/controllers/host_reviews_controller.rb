class HostReviewsController < ApplicationController
  def create
    # Step 1: Check if the booking exist (room_id, guest_id, host_id)

    # Step 2: Check if the current host already reviewed the guest in this booking.

    @booking = Booking.where(
      id: host_review_params[:booking_id],
      venue_id: host_review_params[:venue_id],
      band_id: host_review_params[:band_id]
    ).first

    if !@booking.nil? && @booking.band.user.id == host_review_params[:guest_id].to_i

      @has_reviewed = HostReview.where(
        booking_id: @booking.id,
        guest_id: host_review_params[:guest_id]
      ).first

      if @has_reviewed.nil?
        # Allow to review
        @host_review = current_user.host_reviews.create(host_review_params)
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
    @host_review = Review.find(params[:id])
    @host_review.destroy

    redirect_back(fallback_location: request.referer, notice: 'Removed...!')
  end

  private

  def host_review_params
    params.require(:host_review).permit(:comment, :star, :venue_id, :band_id, :booking_id, :guest_id)
  end
end

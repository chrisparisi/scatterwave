class BandsController < ApplicationController
  before_action :set_band, except: %i[index new create published]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: %i[listing social_media description band_pic_upload location update]

  def index
    @band = current_user.band
  end

  def new
    @band = current_user.band

    redirect_to(listing_band_path(@band), alert: 'You already have created a band') && return if @band
    current_user.update(account_type: "Band")
    @band = current_user.build_band
  end

  def create
    # return redirect_to payment_method_path(payout_tab: true), alert: 'Please connect to Stripe Express first.' unless current_user.is_active_band

    @band = current_user.band

    redirect_to(listing_band_path(@band), notice: 'You already have created a band') && return if @band

    @band = current_user.build_band(band_params)
    if @band.save
      redirect_to listing_band_path(@band), notice: 'Saved...'
    else
      flash[:alert] = 'Something went wrong...'
      render :new
    end
  end

  def show
    @pictures = @band.pictures
    @host_reviews = @band.host_reviews
    @musics = @band.band_musics
    @future_shows = @band.bookings.Approved.where("date >= ?", Time.now)
  end

  def listing; end

  def social_media; end

  def description; end

  def band_pic_upload
    @pictures = @band.pictures
  end

  def band_music_upload
    @band_musics = @band.band_musics
  end

  def published; end

  def update
    new_params = band_params
    new_params = band_params.merge(active: true) if is_ready_band && current_user.merchant_id.present?

    if @band.update(new_params)
      flash[:notice] = 'Saved...'
      redirect_to next_step
    else
      flash[:alert] = 'Something went wrong...'
    end
    #redirect_back(fallback_location: request.referer)
  end

  private

  def set_band
    @band = Band.find(params[:id])
  end

  def is_authorized
    redirect_to root_path, alert: "You don't have permission" unless current_user.id == @band.user_id
  end

  def is_ready_band
    !@band.active && @band.summary.present? && @band.pictures.present? && @band.address.present?
  end

  def band_params
    params.require(:band).permit(:band_type, :band_genre, :band_sec_genre, :band_name, :sound_link, :face_link, :spot_link, :summary, :address, :active, :latitude, :longitude)
  end

  def next_step
    if params[:band][:band_name].present?
      social_media_band_path
    elsif params[:band][:face_link].present?
      description_band_path
    elsif params[:band][:summary].present?
      band_pic_upload_band_path
    elsif params[:band][:images].present?
      band_music_upload_bands_path
    elsif params[:band][:active].present? && params[:band][:active] == "false"
      payment_method_path(payout_tab: true)
    else
      published_bands_path
    end
  end

end

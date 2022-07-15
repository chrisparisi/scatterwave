class BandMusicsController < ApplicationController
  respond_to :html,:json, only: :show

  def create
    @band = Band.find(params[:band_id])
    errors = []
    if params[:musics]
      params[:musics].each do |music|
        if @band.band_musics.count == 10
          errors.push('more than 10 file not allow')
          break;
        end
        band_musics = @band.band_musics.create(music: music)
        errors = errors + band_musics.errors.full_messages
      end
      @band_musics = @band.band_musics
      notice = errors.present? ? "Some of file not being save because of size is greater than 10 MB or not a music file or more than 10 music uploaded" : "Saved..."
      redirect_back(fallback_location: request.referer, notice: notice)
    end
  end

  def destroy
    @music = BandMusic.find(params[:id])
    @band = @music.band

    @music.destroy
    @band_musics = BandMusic.where(band_id: @band.id)

    respond_to :js
  end

  def show
    music = BandMusic.find(params[:id])
    @musics = music.band.band_musics
    respond_with @musics
  end

end

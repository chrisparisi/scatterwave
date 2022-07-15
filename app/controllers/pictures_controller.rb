class PicturesController < ApplicationController
  def create
    @band = Band.find(params[:band_id])

    if params[:images]
      params[:images].each do |img|
        @band.pictures.create(image: img)
      end

      @pictures = @band.pictures
      redirect_back(fallback_location: request.referer, notice: 'Saved...')
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @band = @picture.band

    @picture.destroy
    @pictures = Picture.where(band_id: @band.id)

    respond_to :js
  end
end

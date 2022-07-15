class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @venues = current_user.venues
    @band = current_user.band
  end
end

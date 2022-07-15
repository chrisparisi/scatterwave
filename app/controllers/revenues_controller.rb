class RevenuesController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookings = Booking.current_week_revenue(current_user)

    @this_week_revenue = @bookings.map { |b| { b.updated_at.strftime('%Y-%m-%d') => b.payout } }
                                  .inject({}) { |a, b| a.merge(b) { |_, x, y| x + y } }

    @this_week_revenue = Date.today.all_week.map { |date| [date.strftime('%a'), @this_week_revenue[date.strftime('%Y-%m-%d')] || 0] }
  end
end

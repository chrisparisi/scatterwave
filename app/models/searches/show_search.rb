module Searches
  class ShowSearch
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    FIELDS = :location, :genres, :sdate, :edate, :dates, :name

    attr_accessor *FIELDS

    def initialize(options = {})
      options ||= {}
      FIELDS.each do |field|
        if options[field].is_a?(Array)
          options[field].reject!(&:blank?)
          options[field] = nil if options[field].empty?
        end
        send("#{field}=", options[field])
      end
    end

    def results
      @scope = Venue.where(active: true)
      FIELDS.each do |field|
        send("scope_by_#{field}") if send(field).present?
      end
      send("scope_by_bookings")
      return @scope
    end

    private

    def scope_by_name
      @scope = @scope.where("listing_name Ilike (?)", "%#{name}%")
    end

    def scope_by_location
      @scope = @scope.near(location, 10, order: 'distance')
    end

    def scope_by_genres
      conditions = []
      genres.each do |genre|
        conditions.push("#{genre} = true")
      end
      @scope = @scope.where conditions.join(' or ')
    end

    def scope_by_sdate
    end
    def scope_by_edate
    end
    def scope_by_dates
    end

    def scope_by_bookings
      if dates.present?
        s_date = Date.parse(dates.split(" to ")[0])
        e_date = Date.parse(dates.split(" to ")[1])
        @scope = Booking.Approved.includes(:venue).references(:venue).merge(@scope).where("? <= date AND date <= ?", s_date, e_date)
      else
        @scope = Booking.Approved.includes(:venue).references(:venue).merge(@scope)
      end
    end

  end
end
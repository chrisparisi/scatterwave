module Searches
  class VenueSearch
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    FIELDS = :location, :min_payout, :max_payout, :capacity, :gig_type, :genres, :date, :name

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
      @scope = Venue.where(active: true).joins(:calendars).where(calendars: {status: 'Available'}).distinct
      FIELDS.each do |field|
        send("scope_by_#{field}") if send(field).present?
      end
      return @scope
    end

    private

    def scope_by_name
      @scope = @scope.where("listing_name Ilike (?)", "%#{name}%")
    end

    def scope_by_location
      @scope = @scope.near(location, 10, order: 'distance')
    end

    def scope_by_min_payout
      @scope = @scope.where("venues.payout >= ? AND venues.payout <= ?", min_payout.to_i, max_payout.to_i)
    end

    def scope_by_max_payout
    end

    def scope_by_capacity
      @scope = @scope.where("capacity >= ?", capacity)
    end

    def scope_by_gig_type
      @scope = @scope.where("gig_type IN (?)", gig_type)
    end

    def scope_by_genres
      conditions = []
      genres.each do |genre|
        conditions.push("#{genre} = true")
      end
      @scope = @scope.where conditions.join(' or ')
    end

    def scope_by_date
      dates = Date.parse(date)
      @scope = @scope.where("? <= calendars.day AND calendars.day <= ?", dates, dates)
    end
  end
end

module Searches
  class BandSearch
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    FIELDS = :location, :genres, :name

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
      @scope = Band.where(active: true)
      FIELDS.each do |field|
        send("scope_by_#{field}") if send(field).present?
      end
      return @scope
    end

    private

    def scope_by_name
      @scope = @scope.where("band_name Ilike (?)", "%#{name}%")
    end

    def scope_by_location
      @scope = @scope.near(location, 10, order: 'distance')
    end

    def scope_by_genres
      @scope = @scope.where("band_genre IN (?) OR band_sec_genre IN (?)", genres, genres)
    end
  end
end
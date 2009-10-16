module Velo

  class TrackPoint

    attr_accessor :time, :position, :altitude, :distance,
                  :hr, :cadence, :sensor, :watts

    alias_method :to_s, :inspect
  end

end


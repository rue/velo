require "velo/trackpoint"


module Velo

  class Lap

    ATTRIBUTES =  :start_time, :trigger, :duration, :distance,
                  :speed_max, :calories, :hr_average, :hr_max,
                  :intensity, :cadence_average, :watts_average,
                  :trackpoints

    attr_accessor *ATTRIBUTES

    def initialize()
      super
      self.trackpoints = []
    end

    def inspect()
      s = "#<Lap: "

      ATTRIBUTES.each {|k| s << "#{k}: #{send k} " unless k == :trackpoints }

      s << "(#{trackpoints.size} trackpoints)>"
    end

    alias_method :to_s, :inspect

  end

end

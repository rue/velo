require "velo/device"
require "velo/lap"


module Velo

  class Activity

    attr_accessor :id, :sport, :device, :laps

    def initialize()
      super
      self.laps = []
    end

    def inspect()
      s = "#<Activity #{id}: #{sport}, #{laps.size} laps, device: #{device}>"
    end

    alias_method :to_s, :inspect
  end

end

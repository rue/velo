require "velo/device"
require "velo/part"


module Velo

  class Activity

    attr_accessor :id, :sport, :device, :parts

    def initialize()
      super
      self.parts = []
    end

    def inspect()
      s = "#<Activity #{id}: #{sport}, #{parts.size} parts, device: #{device}>"
    end

    alias_method :to_s, :inspect
  end

end

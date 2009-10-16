require "time"

require "rubygems"
  require "nokogiri"

require "velo/activity"
require "velo/device"
require "velo/lap"
require "velo/trackpoint"


module Velo

  class Activity
    def self.from_tcx(activity)
      a = new

      a.id = activity.css("Id").text
      a.sport = activity["Sport"]
      a.device = Device.from_tcx activity.css("Creator")

      activity.css("Lap").each {|lap|
        a.laps << Lap.from_tcx(lap)
      }

      a
    end
  end

  class Device
    def self.from_tcx(device)
      c = new

      c.name = device.css("Name").text
      c.unit_id = device.css("UnitId").text
      c.product_id = device.css("ProductID").text

      c.version = [device.css("Version VersionMajor").text.to_i,
                   device.css("Version VersionMinor").text.to_i,
                   device.css("Version BuildMajor").text.to_i,
                   device.css("Version BuildMinor").text.to_i]

      c
    end
  end

  class Lap
    def self.from_tcx(lap)
      l = new

      l.start_time = Time.parse lap["StartTime"]
      l.trigger = lap.css("TriggerMethod").text
      l.intensity = lap.css("Intensity").text
      l.duration = lap.css("TotalTimeSeconds").text.to_f
      l.distance = lap.css("DistanceMeters").text.to_f
      l.calories = lap.css("Calories").text.to_f
      l.speed_max = lap.css("MaximumSpeed").text.to_f
      l.hr_average = lap.css("AverageHeartRateBpm").text.to_i
      l.hr_max = lap.css("MaximumHeartRateBpm").text.to_i

      # O.M.G.
      l.cadence_average = lap.children.each {|c| break c.text if c.name == "Cadence" }

      l.watts_average = lap.css("Extensions").children.first.children.text.to_i

      lap.css("Track Trackpoint").each {|point|
        l.trackpoints << TrackPoint.from_tcx(point)
      }

      l
    end
  end

  class TrackPoint
    def self.from_tcx(trackpoint)
      t = new

      t.time = Time.parse trackpoint.css("Time").text
      t.position = [trackpoint.css("Position LatitudeDegrees").text,
                    trackpoint.css("Position LongitudeDegrees").text]
      t.altitude = trackpoint.css("AltitudeMeters").text.to_f
      t.distance = trackpoint.css("DistanceMeters").text.to_f
      t.hr        = trackpoint.css("HeartRateBpm Value").text.to_i
      t.cadence      = trackpoint.css("Cadence").text.to_i
      t.sensor = trackpoint.css("SensorState").text

      # Ugh. Namespacing problem, and the workaround is painful.
      t.watts = trackpoint.css("Extensions").children.first.children.text.to_i

      t
    end
  end

end


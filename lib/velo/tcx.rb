require "time"

require "rubygems"
  require "nokogiri"


class Activity < Struct.new(:id, :sport, :creator, :laps)

  def self.from(activity)
    a = new

    a.id = activity.css("Id").text
    a.sport = activity["Sport"]
    a.creator = Creator.from activity.css("Creator")

    activity.css("Lap").each {|lap|
      a.laps << Lap.from(lap)
    }

    a
  end

  def initialize()
    super
    self.laps = []
  end

  def inspect()
    s = "#<Activity: "

    each_pair {|k, v| s << "#{k}: #{v} " unless k == :laps }

    s << "(#{laps.size} laps)>"
  end
end

class Creator < Struct.new(:name, :unit_id, :product_id, :version)

  def self.from(creator)
    c = new

    c.name = creator.css("Name").text
    c.unit_id = creator.css("UnitId").text
    c.product_id = creator.css("ProductID").text

    c.version = [creator.css("Version VersionMajor").text.to_i,
                 creator.css("Version VersionMinor").text.to_i,
                 creator.css("Version BuildMajor").text.to_i,
                 creator.css("Version BuildMinor").text.to_i]

    c
  end
end

class Lap < Struct.new(:start_time, :trigger, :duration, :distance,
                       :speed_max, :calories, :hr_average, :hr_max,
                       :intensity, :cadence_average, :watts_average,
                       :trackpoints)

  def self.from(lap)
    l = new

    l.start_time = Time.parse lap["StartTime"]
    l.trigger = lap.css("Trigger").text
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
      l.trackpoints << TrackPoint.from(point)
    }

    l
  end

  def initialize()
    super
    self.trackpoints = []
  end

  def inspect()
    s = "#<Lap: "

    each_pair {|k, v| s << "#{k}: #{v} " unless k == :trackpoints }

    s << "(#{trackpoints.size} trackpoints)>"
  end

end

class TrackPoint < Struct.new(:time, :position, :altitude, :distance,
                              :hr, :cadence, :sensor, :watts)

  def self.from(trackpoint)
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

require "lib/velo/tcx"

# IRB dies on ARGF trying to start it here..
$xml = File.open(ARGV.first) {|f| Nokogiri::XML.parse f }
$a = Velo::Activity.from_tcx $xml.css("Activity").first

p $a, $a.laps.first, $a.laps.first.trackpoints.first

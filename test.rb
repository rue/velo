files = Dir.glob "/Users/ruerue/Documents/705\ Backups/2009-10-15/History/*.tcx"
load "lib/velo/tcx.rb"
$xml = Nokogiri::XML.parse(File.open files[-4])
$a = Activity.from $xml.css("Activity").first


#!/usr/bin/perl
use strict;
use warnings;

use JSON;
use Data::Dumper;
use POSIX qw{strftime};
use utf8;
use Encode;
use CGI;
my $q = CGI->new;

sub converttime { 
	my $input = int(shift);
	my $milliseconds = $input % 1000;
	$input = $input / 1000;
	my $seconds = $input % 60;
	$input = $input / 60;
	my $minutes = $input;
	return(sprintf("%d:%02d.%03d", $minutes, $seconds, $milliseconds));
}

sub convertplayersetup {
	my $setupid = shift;
	my $setup;
	my $control_set = 'false';
	my $model_set = 'false';

	my (@models,@controls,@aids,@ownsetup);

        # Remove verification
        $setupid = $setupid - 1073741824;

	# Aid: Drivingline
	if ($setupid > 32767) {
		$setupid = $setupid - 32768;
		push @aids, '<img src="https://cdn4.iconfinder.com/data/icons/map-and-navigation-line-vol-4/52/street__road__driving__straight__transport__speed__oneway-256.png" alt="drivingline" height="24" width="24">';
	}

        # Model: Mask
        if (($model_set eq 'false') && ($setupid > 14335)) {
                $setupid = $setupid - 14336;
                push @models, '<img src="https://i.pinimg.com/originals/ec/fe/e7/ecfee7ecbe1770d349856b0c0a8e846e.jpg" alt="model_mask" height="24" width="24">';
        }

        # Model: Elite
        if (($model_set eq 'false') && ($setupid > 8191)) {
                $setupid = $setupid - 8192;
                push @models, '<img src="https://zapier.cachefly.net/storage/photos/28d71e04b638894d922f590e41bc49ad.png" alt="model_elite" height="24" width="24">';
        }

        # Model: Pro
        if (($model_set eq 'false') && ($setupid > 6143)) {
                $setupid = $setupid - 6144;
                push @models, '<img src="http://icongal.com/gallery/image/98937/circle_grey.png" alt="model_pro" height="24" width="24">';
        }

        # Model: Experienced
        if (($model_set eq 'false') && ($setupid > 4095)) {
                $setupid = $setupid - 4096;
                push @models, '<img src="http://cdn.mysitemyway.com/etc-mysitemyway/icons/legacy-previews/icons-256/simple-red-glossy-icons-symbols-shapes/020906-simple-red-glossy-icon-symbols-shapes-circle-solid.png" alt="model_experienced" height="24" width="24">';
        }

        # Model: Normal
        if (($model_set eq 'false') && ($setupid > 2047)) {
                $setupid = $setupid - 2048;
		push @models, '<img src="https://arve0.github.io/example_lessons/assets/img/level1.png" alt="model_normal" height="24" width="24">';
        }

        # Aid: Auto Clutch
        if ($setupid > 1023) {
		$setupid = $setupid - 1024;
		push @aids, '<img src="https://cdn3.iconfinder.com/data/icons/car-elements-2/64/CLUTCH_DISC-128.png" alt="autoclutch" height="24" width="24">';
        }

        # Aid: Auto Gears
        if ($setupid > 511) {
                $setupid = $setupid - 512;
                push @aids, '<img src="https://image.flaticon.com/icons/png/128/60/60473.png" alt="autogears" height="24" width="24">';
        }

        # Aid: No Damage
        if ($setupid > 255) {
                $setupid = $setupid - 256;
                push @aids, '<img src="https://image.flaticon.com/icons/png/128/104/104951.png" alt="nodmg" height="24" width="24">';
        }

        # Aid: Stability
        if ($setupid > 127) {
                $setupid = $setupid - 128;
                push @aids, '<img src="https://cdn4.iconfinder.com/data/icons/metaphors/100/13-128.png" alt="stability" height="24" width="24">';
        }

        # Aid: Traction
        if ($setupid > 63) {
                $setupid = $setupid - 64;
                push @aids, '<img src="https://cdn.iconscout.com/public/images/icon/premium/png-128/traction-control-3b9f22b4ef960c70-128x128.png" alt="traction" height="24" width="24">';
        }

        # Aid: ABS
        if ($setupid > 31) {
                $setupid = $setupid - 32;
                push @aids, '<img src="https://cdn4.iconfinder.com/data/icons/automotive-maintenance/100/auto_warning-abs-128.png" alt="abs" height="24" width="24">';
        }

        # Aid: Braking
        if ($setupid > 15) {
                $setupid = $setupid - 16;
		push @aids, '<img src="https://cdn1.iconfinder.com/data/icons/car-parts-and-accessories-volume-01/32/disc-brake-car-part-vehicle-service-drum-128.png" alt="braking" height="24" width="24">';
        }

        # Aid: Steering
        if ($setupid > 7) {
                $setupid = $setupid - 8;
                push @aids, '<img src="https://www.shareicon.net/data/128x128/2015/12/04/682238_wheel_512x512.png" alt="steering" height="24" width="24">';
        }

        # Controller: Mask
        if (($control_set eq 'false') && ($setupid > 5)) {
                $setupid = $setupid - 6;
		push @controls, '<img src="https://cdn4.iconfinder.com/data/icons/vr-virtual-reality/84/vr1-256.png" alt="mask" height="24" width="24">';
        }

        # Controller: Wheel
        if (($control_set eq 'false') && ($setupid > 3)) {
                $setupid = $setupid - 4;
		push @controls, '<img src="http://icons.iconarchive.com/icons/icons8/windows-8/24/Transport-Steering-Wheel-icon.png" alt="wheel" height="24" width="24">';
        }

        # Controller: Gamepad
        if (($control_set eq 'false') && ($setupid > 1)) {
                $setupid = $setupid - 2;
		push @controls, '<img src="https://image.flaticon.com/icons/png/128/25/25428.png" alt="gamepad" height="24" width="24">';
        }

        # Used own Setup
        if ($setupid == 1) {
                $setupid = $setupid - 1;
                push @ownsetup, '<img src="http://www.i2symbol.com/images/symbols/check/heavy_check_mark_u2714_icon_256x256.png" alt="Own Setup" height="24" width="24">';
        }

	# Check if remaining flagsize is 0 now
	if ($setupid == 0) {
		return (\@controls,\@models,\@aids,\@ownsetup);
	}
}

# Read vehicles json
my $vehiclejsonstring;
{
  local $/;
  open my $fh, "<", "vehicles.json";
  $vehiclejsonstring = <$fh>;
  close $fh;
}
my $vehiclejsonhash = decode_json($vehiclejsonstring);
my @vehicles = @{ $vehiclejsonhash->{'response'}->{'list'} };

# Read stats json
my $jsonstring;
{
  local $/;
  open my $fh, "<", "sms_stats_data.json";
  $jsonstring = <$fh>;
  close $fh;
}

# Remove first two lines and EOF
$jsonstring =~ s/^\/\/ Persistent data for addon 'sms_stats', addon version 2.0//g;
$jsonstring =~ s/\/\/ Automatically maintained by the addon, do not edit!//g;
$jsonstring =~ s/\/\/ EOF \/\///g;

# Remove Unicode
$jsonstring =~ s/[^[:ascii:]]//g;

# Encode UTF8
my $octets = encode("utf8", $jsonstring, Encode::FB_DEFAULT);
my $utf8string = decode("utf8", $octets, Encode::FB_DEFAULT);

# Decode JSON to Hash
my $jsonhash = decode_json($utf8string);

# Define a few things...
my $stats = $jsonhash->{'stats'};
my $servername = $jsonhash->{'stats'}->{'server'}->{'name'};
my $serveruptime = int($jsonhash->{'stats'}->{'server'}->{'uptime'} / 60 / 60);
my $totalserveruptime = int($jsonhash->{'stats'}->{'server'}->{'total_uptime'} / 60 / 60);
my @history = @{ $jsonhash->{'stats'}->{'history'} };
my @tabledata;

# Venture thru the History
foreach my $f ( @history ) {
	if (!$f->{'stages'}->{'practice1'}) { next; } # Whoops! We only track practice for now!
	my @members = $f->{'members'};
	my @events = @{ $f->{'stages'}->{'practice1'}->{'events'} };

	# Look for LapTime events
	foreach my $e (@events) {
		if ($e->{'event_name'} eq 'Lap') { # We have a Lap
			my $starttime = $e->{'time'};
			my $start_time = scalar localtime($starttime);
			my @attributes = $e->{'attributes'};

			foreach my $a (@attributes) {
				if ($a->{'CountThisLapTimes'} == 1) { # And we count it!
					# More defines here
					my $steamID;
					my $carID;
					my $car;
					my $carclass;
					my $flags;
					my $racer_name = $e->{'name'};
					my $lap_time = &converttime($a->{'LapTime'});
					my $sector_1_time = &converttime($a->{'Sector1Time'});
					my $sector_2_time = &converttime($a->{'Sector2Time'});
					my $sector_3_time = &converttime($a->{'Sector3Time'});
					my $refID = $e->{'refid'};

					# Read from @members and get carID
					foreach my $m (@members) {
						$steamID = $m->{"$refID"}->{'steamid'};
						$carID = $m->{"$refID"}->{'setup'}->{'VehicleId'};
						$flags = $m->{"$refID"}->{'setup'}->{'RaceStatFlags'};
					}

					# Check carID against @vehicles
					foreach my $c (@vehicles) {
						if ($carID == $c->{id}) {
							$car = $c->{'name'};
							$carclass = $c->{'class'};
						}
					}

					# Get the players setup
					my ($controls,$model,$aids,$ownsetup) = &convertplayersetup($flags);

					# Define an ugly row and push it into @tabledata
					my $row = ("<tr><td class=\"name\"><a href=\"https://steamcommunity.com/profiles/$steamID\">$racer_name</a></td><td class=\"car\">$car</td><td class=\"carclass\">$carclass</td><td class=\"laptime\">$lap_time</td><td class=\"sector1\">$sector_1_time</td><td class=\"sector2\">$sector_2_time</td><td class=\"sector3\">$sector_3_time</td><td class=\"date\">$start_time</td><td class=\"control\">@$controls</td><td class=\"aids\">@$aids</td><td class=\"ownsetup\">@$ownsetup</td></tr>");
					push @tabledata, $row;
				}
			}
		}
	}
}

# HTML
print ("<head>\n");
print ("<link rel='stylesheet' type='text/css' href='generatestats.css'>\n");
print ("<script src='list.min.js'    type='text/javascript'></script>\n");
print ("<title>Report for $servername</title>\n");
print ("</head>\n");
print ("<body>\n");
print $q->h1($servername) . "\n";

my $generatedstring = ("Generated at " . scalar localtime(time) . "\n");
print $q->h5($generatedstring) . "\n";

print ("<div id=\"results\">\n");
print ("<button class=\"sort\" data-sort=\"name\">Name</button>\n");
print ("<button class=\"sort\" data-sort=\"car\">Car</button>\n");
print ("<button class=\"sort\" data-sort=\"carclass\">Class</button>\n");
print ("<button class=\"sort\" data-sort=\"laptime\">Lap Time</button>\n");
print ("<button class=\"sort\" data-sort=\"sector1\">Sector 1</button>\n");
print ("<button class=\"sort\" data-sort=\"sector2\">Sector 2</button>\n");
print ("<button class=\"sort\" data-sort=\"sector3\">Sector 3</button>\n");
print ("<button class=\"sort\" data-sort=\"date\">Date</button>\n");
print ("<input class=\"search\" placeholder=\"Search\" />\n");

print ("<table>\n");
print ("<tbody class=\"list\">\n");

print ("<tr><td>Name</td><td>Car</td><td>Class</td><td>Lap Time</td><td>Sector 1</td><td>Sector 2</td><td>Sector 3</td><td>Date</td><td>Controls</td><td>Aids</td><td>Setup</td></tr>");
foreach (@tabledata) {
print "$_\n";
}

print ("</tbody>\n");
print ("</table>\n");
print ("</div>\n");

print ("\n");

print ("<script>\n");
print ("var options = \{ valueNames: \[ 'name', 'car', 'carclass', 'laptime', 'sector1', 'sector2', 'sector3', 'date' \], pagination: true \};\n");
print ("var resultsList = new List\('results', options\);\n");
print ("</script>\n");

my $uptimestring = ("Uptime: $serveruptime hours | All Time: $totalserveruptime hours\n");
print $q->h6($uptimestring) . "\n";

print $q->end_html;


// Copyright 2010 D1plo1d

// This library is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/ .

testNutsAndBolts();

module testNutsAndBolts()
{
	$fn = 360;
	translate([0,15]) linear_extrude(10) nutHole(3, proj=2);
	boltHole(3, length= 30, proj=-1);
}

MM = "mm";
INCH = "inch"; //Not yet supported

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
METRIC_NUT_AC_WIDTHS =
[
	-1, //0 index is not used but reduces computation
	-1,
	//changed to mean dimension (max+min)/2
	// source : https://www.engineersedge.com/hardware/standard_metric_hex_nuts_13728.htm
	(4.62+4.32)/2,//m2
	(6.35+6.01)/2,//m3 -- initialy 6.4
	(8.08+7.66)/2,//m4 -- initialy 8.10
	(9.24+8.79)/2,//m5
	(11.55+11.05)/2,//m6
	-1,
	(15.01+14.38)/2,//m8
	-1,
	(18.48+17.77)/2,//m10
	-1,
	(20.78+20.03)/2,//m12
	-1,
	(24.25+23.36)/2,//m14
	-1,
	(27.71+26.75)/2,//m16
	-1,
	-1,
	-1,
	(34.64+32.95)/2,//m20
	-1,
	-1,
	-1,
	(41.57+39.55)/2,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	(53.12+50.85)/2,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	(63.51+60.79)/2//m36
];
METRIC_NUT_THICKNESS =
[
	-1, //0 index is not used but reduces computation
	-1,
	1.6,//m2
	2.40,//m3
	3.20,//m4
	4.00,//m5
	5.00,//m6
	-1,
	6.50,//m8
	-1,
	8.00,//m10
	-1,
	10.00,//m12
	-1,
	-1,
	-1,
	13.00,//m16
	-1,
	-1,
	-1,
	16.00//m20
	-1,
	-1,
	-1,
	19.00,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	24.00,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	29.00//m36
];

COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS =
[//based on max values
	-1, //0 index is not used but reduces computation
	-1,
	2,//m2
	2.98,//m3
	3.978,//m4
	4.976,//m5
	5.974,//m6
	-1,
	7.972,//m8
	-1,
	9.968,//m10
	-1,
	11.966,//m12
	-1,
	-1,
	-1,
	15.962,//m16
	-1,
	-1,
	-1,
	19.958,//m20
	-1,
	-1,
	-1,
	23.952,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	29.947,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	35.940//m36
];

// Deprecated, but kept around for people who use the wrong spelling.
COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS = COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS;

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/cap_screws.htm
METRIC_BOLT_CAP_DIAMETERS =
[
	-1, //0 index is not used but reduces computation
	-1,
	3.75,//m2
	5.50,//m3
	7.00,//m4
	8.50,//m5
	10.00,//m6
	-1,
	13.00,//m8
	-1,
	16.00,//m10
	-1,
	18.00,//m12
	-1,
	-1,
	-1,
	24.00,//m16
	-1,
	-1,
	-1,
	30.00//m20
	-1,
	-1,
	-1,
	36.00,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	45.00,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	54.00//m36
];

module nutHole(size, units=MM, tolerance = +0.0001, proj = -1)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = METRIC_NUT_AC_WIDTHS[size]/2+tolerance;
	height = METRIC_NUT_THICKNESS[size]+tolerance;
	if (proj == -1)
	{
		cylinder(r= radius, h=height, $fn = 6, center=true); //centered now
	}
	if (proj == 1)
	{
		circle(r= radius, $fn = 6);
	}
	if (proj == 2)
	{
		translate([-radius*sqrt(3)/2, -height/2])
			square([2*radius*sqrt(3)/2, height]); //changed to small dimension
		//echo(2*radius*sqrt(3)/2); // debug print
	}
}

module boltHole(size, units=MM, length, length_up=undef, tolerance = +0.0001, proj = -1)
{
	radius = COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS[size]/2+tolerance;
	capHeight = length_up==undef?size+tolerance:length_up;
	capRadius = METRIC_BOLT_CAP_DIAMETERS[size]/2+tolerance;

	if (proj == -1)
	{
	translate([0, 0, -capHeight])
		cylinder(r= capRadius, h=capHeight);
    //translate and extra length: better display on preview
	translate([0,0,-0.1]) cylinder(r = radius, h = length+0.1);
	}
	if (proj == 1)
	{
		circle(r = radius);
	}
	if (proj == 2)
	{
		translate([-capRadius/2, -capHeight])
			square([capRadius*2, capHeight]);
		square([radius*2, length]);
	}
}

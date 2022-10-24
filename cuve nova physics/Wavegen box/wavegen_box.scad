/*

	Wave Generator
	Box for electronics
	
	Olivier Boesch (c) 2021

*/

use <arduino.scad>

//render (number of segments for a circle)
$fn=150;

//External dimensions
Length = 90;
Width = 80;
Height = 40;

//rounding or chamfering
box_rounding = false; //true: round; false: chamfer
box_radius = 10;  //rounding radius
box_chamfer = 10;  //chamfer

//attach
attach_height=8;

//material
ep = 2;

//cutaway oversize
eps = 0.1;

//hole screw size
d_hole_screw = 2.3;
//hole insert size
d_hole_fix = 3.2;

//clearance in box for panels
panel_clearance = 0.2;

//panel material
panel_ep = 1.5;

//ventilation holes
ventilation_holes = true;

// What should i draw in preview
draw_top = true;
draw_bottom = true;
draw_left = true;
draw_right = true;

//exploded view
exploded_view = false; //false: normal preview; true: exploded view

//colors (only for preview)
up_down_color = "#444444";
left_right_color = "#726666";


/* ------------------------------

	Context

*/
if($preview){
	translate([23,-28,-13]) rotate([0,0,180]) Arduino();
	place_on(face="left", x=-15, y=5) translate([0,0,10]) color("black") cylinder(d=12, h=25, center=true);
	place_on(face="left", x=5, y=5) translate([0,0,10]) color("red") cylinder(d=12, h=25, center=true);
	place_on(face="top", x=11, y=-20) color("white", 0.4) translate([0,0,28]) rotate([180,0,0]){
			cylinder(d=2,h=30);
			translate([0,0,29]) cylinder(d1=4, d2=2,h=1);
		}
	place_on(face="top", x=-20.5, y=-14) color("white", 0.4) translate([0,0,28]) rotate([180,0,0]){
			cylinder(d=2,h=30);
			translate([0,0,29]) cylinder(d1=4, d2=2,h=1);
		}
}

// -------------------------------

/* -----------------------------------------------------

	Holes on panels and shells (add here your holes)
	examples:
		cube_hole(x=3,y=6, L=15, l=5);
		cylinder_hole(x=0,y=-20, d=12);
		text_on(x=0, y=10, s="St Ex",font="Chakra Petch:style=Regular");

*/

//top of box
module top_holes(){
	text_on(x=0, y=10, size=8, s="WaveGen",font="Chakra Petch:style=Regular");
	text_on(x=0, y=-5, size=8, s="Mk2",font="Chakra Petch:style=Regular");
	text_on(x=11, y=-26, size=6, s="act",font="Chakra Petch:style=Regular");
	cylinder_hole(x=11,y=-20, d=2.2);
	text_on(x=-20.5, y=-20, size=6, s="on",font="Chakra Petch:style=Regular");
	cylinder_hole(x=-20.5,y=-14, d=2.2);
}

//bottom of box
module bottom_holes(){
	text_on(x=15, y=0, angle=-90, size=15, s="St Ex",font="Chakra Petch:style=Regular");
	text_on(x=-15, y=0, angle=-90, size=15, s="PC",font="Chakra Petch:style=Regular");
}

//left panel
module left_holes(){
	cylinder_hole(x=-15,y=5, d=12);
	cylinder_hole(x=5,y=5, d=12);
}

//right panel
module right_holes(){
	cube_hole(x=-15.5,y=-5.7, L=13, l=12);
}

//-------------------------------

/* -------------------------------------------------------------
	holes for screws on bottom (add here your holes for screws)
		example:
			screw_hole(x=0, y=0, d_hole=2, d_ext=4, h=10);
*/

module bottom_screws(){
	screw_hole(x=24, y=20, d_hole=3.2, d_ext=3.2+2, h=4+1);
	screw_hole(x=-28, y=15, d_hole=3.2, d_ext=3.2+2, h=4+1);
	screw_hole(x=23, y=-28, d_hole=3.2, d_ext=3.2+2, h=4+1);
	screw_hole(x=-28, y=-13, d_hole=3.2, d_ext=3.2+2, h=4+1);
}

//-------------------------------

/*

holes functions

*/

module cylinder_hole(x=0,y=0, d=1){
	translate([x,-y]) cylinder(d=d, h=ep+2*eps,center=true);
}

module cube_hole(x=0,y=0, L=5, l=5, angle=0){
	translate([x,-y]) rotate([0,0,angle]) cube([L, l, ep+2*eps],center=true);
}

module text_on(x=0, y=0, s="test", font="", size=10, valign="center", halign="center", angle=0){
	translate([x,-y,-ep/2-eps]) rotate([0,0,angle]) linear_extrude(ep/2+eps) rotate([180,0,0]) text(s, font=font, size=size, valign=valign, halign=halign);
}

module screw_hole(x=0, y=0, d_hole=2, d_ext=4, h=5){
	translate([x,y,-Height/2+ep/2]) difference(){
		union(){
			cylinder(d=d_ext, h=h+ep/2);
			cylinder(d1=d_ext+2, d2=d_ext, h=h/2+ep/2);
		}
		cylinder(d=d_hole, h=h+ep/2+eps);
	}
}

module place_on(face="top", x=0, y=0, angle=0, explode=true){
	if(face == "top") {
		if (exploded_view && explode) rotate([180,0,0]) translate([x,-y,-Height/2+ep/2-Height]) rotate([0,0,angle]) children(0);
		else rotate([180,0,0]) translate([x,-y,-Height/2+ep/2]) rotate([0,0,angle]) children(0);
	}
	if(face == "bottom") {
		if(exploded_view && explode) translate([x,y,-Height/2+ep/2-Height]) rotate([0,0,angle]) children(0);
		else translate([x,y,-Height/2+ep/2]) rotate([0,0,angle]) children(0);
	}
	if(face == "left"){
		if(exploded_view && explode) translate([-(Length-panel_ep)/2+ep+panel_clearance-Length,0,0]) rotate([-90,0,0]) rotate([0,90,0]) translate([x,-y]) rotate([0,0,angle]) children(0);
		else translate([-(Length-panel_ep)/2+ep+panel_clearance,0,0]) rotate([-90,0,0]) rotate([0,90,0]) translate([x,-y]) rotate([0,0,angle]) children(0);
	}
	if(face == "right") {
		if(exploded_view && explode) translate([(Length-panel_ep)/2-ep-panel_clearance+Length,0,0]) rotate([0,180,0]) rotate([90,0,0]) rotate([0,90,0]) translate([x,-y]) rotate([0,0,angle]) children(0);
		else translate([(Length-panel_ep)/2-ep-panel_clearance,0,0]) rotate([0,180,0]) rotate([90,0,0]) rotate([0,90,0]) translate([x,-y]) rotate([0,0,angle]) children(0);
	}
}

//--------------------------------

/*
	Box
*/

//box profile
module box_profile(l,w){
	if(box_rounding){
		offset(r=box_radius) square([l-2*box_radius,w-2*box_radius], center=true);
	}
	else{
		offset(delta=box_chamfer, chamfer=true) square([l-2*box_chamfer,w-2*box_chamfer], center=true);
	}
}

//general box (outer)
module general_box(l,w,h){
	rotate([90,0,90]) linear_extrude(l,center=true) box_profile(w, h);
}

//scaled box from general one (to make a clean panel and inner space)
module scaled_box(l, body_offset){
	rotate([90,0,90]) linear_extrude(l,center=true) offset(delta=body_offset/2) box_profile(Width, Height);
}

//outer half box
module outer_box(){
	difference(){
		general_box(Length, Width, Height);
		translate([0,0,Height/4+eps/2]) cube([Length+eps,Width+eps,Height/2+eps],center=true);
	}
}

//inner space
module inner_box(){
	scaled_box(Length-2*(+panel_ep+2*panel_clearance+2*ep), -2*ep);
}

//box lock
module lock(hole=false){
	if(hole){
		rotate([90,0,0]) cylinder(d=attach_height*2+panel_clearance, h=ep+panel_clearance,$fn=6,center=true);
	}
	else{
		rotate([90,0,0]) cylinder(d=attach_height*2, h=ep,$fn=6,center=true);
	}
}

//panel
module panel(){
	scaled_box(panel_ep, -2*ep-panel_clearance);
}

//halfbox (complete)
module halfbox(){
	difference(){
		//outer shape
		outer_box();
		//ventilation
		for(i=[-Length/2+10:5:Length/2-10]) {
			if((ventilation_holes) && (abs(i) != Length/4) && (Height >= 40)){
				translate([i,0,-Height/2+Height/8+2*ep]) cube([ep,Width+eps,Height/4], center=true);
			}
		}
		//inner shape (hole)
		inner_box();
		//ends for panel
		for(i=[-1,1]) translate([i*(Length-panel_ep-2*panel_clearance-2*ep)/2,0,0]){
			scaled_box(panel_ep+2*panel_clearance+2*ep+2*eps,-6*ep);
			scaled_box(panel_ep+2*panel_clearance,-2*ep-2*panel_clearance);
		}
		for(i=[-1,1]){
			translate([i*Length/4,-Width/2+ep,0]){
				lock(hole=true);
				translate([0,0,-attach_height/2]) rotate([90,0,0]) cylinder(d=d_hole_screw, h=2*ep+eps, center=true);
			}
		}
	}
	for(i=[-1,1]){
		translate([i*Length/4,Width/2-ep,0]) difference(){
			lock();
			translate([0,0,attach_height/2]) rotate([90,0,0]) cylinder(d=d_hole_fix, h=2*ep+eps, center=true);
		}
	}
}

module bottom(){
	difference(){
		halfbox();
		translate([0,0,-Height/2+ep/2]) bottom_holes();
	}
	bottom_screws();
}

module top(){
	difference(){
		halfbox();
		translate([0,0,-Height/2+ep/2]) top_holes();
	}
}

module left(){
	difference(){
		panel();
		rotate([-90,0,0]) rotate([0,90,0]) left_holes();
	}
}

module right(){
	difference(){
		panel();
		rotate([0,180,0]) rotate([90,0,0]) rotate([0,90,0]) right_holes();
	}
}

if($preview && !exploded_view){
	//bottom
	if(draw_bottom) color(up_down_color) bottom();
	//top
	if(draw_top) color(up_down_color) rotate([180,0,0]) top();
	//right
	if(draw_right) color(left_right_color) translate([(Length-panel_ep)/2-ep-panel_clearance,0,0]) right();
	//left
	if(draw_left) color(left_right_color) translate([-(Length-panel_ep)/2+ep+panel_clearance,0,0]) left();
}
if($preview && exploded_view){
	//bottom
	if(draw_bottom) color(up_down_color) translate([0,0,-Height/2]) bottom();
	//top
	if(draw_top) color(up_down_color) translate([0,0,Height/2]) rotate([180,0,0]) top();
	//right
	if(draw_right) color(left_right_color) translate([(Length-panel_ep)/2-ep-panel_clearance+Length/2,0,0]) right();
	//left
	if(draw_left) color(left_right_color) translate([-(Length-panel_ep)/2+ep+panel_clearance-Length/2,0,0]) left();
}
if(!$preview){
	//bottom
	bottom();
	//top
	translate([0,Width+10,0]) top();
	//right
	translate([Length/2+Height/2+10,0,-Height/2+panel_ep/2]) rotate([0,90,0]) right();
	//left
	translate([Length/2+Height/2+10,Width+10,-Height/2+panel_ep/2]) rotate([0,-90,0]) left();
}
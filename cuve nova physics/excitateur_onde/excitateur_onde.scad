/*

	Excitateur pour cuve à vagues Nova Physics

	ref : https://www.nova-physics.com/product-page/tp-complet-sur-l-etude-des-ondes-dans-un-canal-a-vagues


*/

use <MCAD/nuts_and_bolts.scad>
use <MCAD/bearing.scad>

$fn=150;

L = 130;
l = 60;
h = 110;

bearing = 626;
bearing_dims = bearingDimensions(bearing);

e_roue = 1.5;
e_vide_roue = 5;

d_axe = 10;
p_axe = 30;
pos_axe = [0, 20, h/2];
tol_axe = 0.5;

d_vis = 4;
l_vis = 20;
tol_ecrou = 0.1;

r_ellipse = 60;
R_ellipse = 105;

eps = 0.02;

module logement_roulement(){
	rotate([0,90,0]) {
		cylinder(d=bearing_dims[1]+2*e_roue+2*e_vide_roue, h=bearing_dims[2]+1, center=true);
		translate([0,8,7.5]) rotate([90,0,0]) linear_extrude(15, convexity=15) nutHole(size=d_vis, tolerance = tol_ecrou, proj = 2);
		translate([0,0,-9]) boltHole(size=d_vis, length=l_vis, tolerance = 0.3);
	}
}

module adapt_axe(){
	rotate([0,90,0]) difference(){
		cylinder(d=bearing_dims[0]-0.05, h=bearing_dims[2]+1, center=true);
		cylinder(d=d_vis+0.2, h=8, center=true);
	}
}

module roue(){
	rotate([0,90,0]) difference(){
		cylinder(d=bearing_dims[1]+2*e_roue, h=6, center=true);
		cylinder(d=bearing_dims[1]-0.2, h=7, center=true);
	}
}

module excitateur(){
	color("#444444") difference(){
		union(){
			translate([0,0,5]) cube([L, l, h], center=true);
			translate([0,0,60]) cylinder(d=25, h=40, center=true);
		}
		translate([0,l/2+5,-h/2]) rotate([0,90,0]) scale([R_ellipse/r_ellipse,1,1]) cylinder(r = r_ellipse, h = L+2*eps, center=true);
		translate([-52,-25,42]) logement_roulement();
		translate([52,-25,42]) mirror([1,0,0]) logement_roulement();
		translate([0,0,60]){
			//cylinder(d=d_axe + tol_axe, h=41, center=true);
			hull(){
				translate([0,-5,0]) cylinder(d=d_axe/2-0.5, h=41, center=true);
				translate([-5,3,0]) cylinder(d=d_axe/2, h=41, center=true);
				translate([5,3,0]) cylinder(d=d_axe/2, h=41, center=true);
			}
			translate([-2,8,5.8]) linear_extrude(15, convexity=15) nutHole(size=d_vis, tolerance = tol_ecrou, proj = 2);
			translate([0,8,10]) rotate([90,0,0]) cylinder(d=d_vis+0.2, h=10, center=true);
		}
		//cube(200); // cut
	}
	if($preview){
		color("DarkGray") translate([0,8,70]) rotate([0,90,90]){
			nutHole(size=d_vis);
			translate([0,0,6]) rotate([180,0,0])boltHole(size=d_vis, length=8);
		}
		
		color("red", 0.3) translate([0,0,60]) cylinder(d=d_axe, h=50);
	}
}

/*function profile_data(a,b,c) = [for(p = [0:$fn]) [p, a*p*p + b*p + c]];

module profile(a, b, c, h){
    data = profile_data(a,b,c);
    linear_extrude(h, convexity=15) polygon(data);
}*/

//profile(0.01,0.02,3,30);
if($preview){
	excitateur();
	bearing(pos=[-52,-25,42],angle=[0,90,0], model=bearing);
	bearing(pos=[52,-25,42],angle=[0,90,0], model=bearing);
	color("Blue"){
		translate([-52,-25,42]) roue();
		translate([52,-25,42]) roue();
	}
	color("DarkGray"){
		translate([-62,-25,42]) rotate([0,90,0]) boltHole(size=d_vis, length=l_vis);
		translate([-44.5,-25,42]) rotate([0,90,0]) rotate([0,0,30]) nutHole(size=d_vis);
		translate([62,-25,42]) rotate([0,-90,0]) boltHole(size=d_vis, length=l_vis);
		translate([44.5,-25,42]) rotate([0,90,0]) rotate([0,0,30]) nutHole(size=d_vis);
	}
	color("#444444") {
		translate([-52,-25,42]) adapt_axe();
		translate([52,-25,42]) adapt_axe();
	}
}
else{
	translate([0,0,l/2]) rotate([90,0,0]) excitateur();
	translate([0,0,3]) rotate([0,90,0]) translate([0,L/2+20,0]) {
		translate([0,0,-20]) roue();
		translate([0,0,20]) roue();
		translate([-0.5,0,-40]) adapt_axe();
		translate([-0.5,0,40]) adapt_axe();
	}//*/
}
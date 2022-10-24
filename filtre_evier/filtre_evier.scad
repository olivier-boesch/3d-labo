/*

Filtre évier pour évier standard de chimie
D = 38mm


Olivier Boesch (c) 2022


*/

use <honeycomb_2D.scad>

$fn=200;

d_ext = 37;
ep_support = 2;
ep_grille = 1;
h_ext = 5;
h_int = 2;
hole_size = 6;

linear_extrude(h_ext){
	difference(){
		circle(d=d_ext);
		circle(d=d_ext - ep_support);
	}
}
linear_extrude(h_int){
	intersection(){
		translate([1.1,0.5,0]) honeycomb_2D(L=d_ext, l=d_ext, hole=hole_size, ep=ep_grille);
		circle(d=d_ext-ep_support/2);
	}
}

cylinder(d=6, h=20);
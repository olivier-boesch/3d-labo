use <threadlib/threadlib.scad>
use <text_on.scad>

/*

	Avant nez pour éolienne Sordalab

*/


$fn = $preview?80:300;

D_haut = 28;
D_bas = 39;
D_int = 21;
H_int = 6.3;
H = 8.7;
H_dessous = 13.5 - H;
D_dessous = 20.6;

//filetage
type_filetage = "M18x1.5";
tol_filetage = 0.15;
d_trou = 18+0.6;

//marques ou texte
marques = true;

//marques
n_marques = 6;
angle_marques = atan((D_haut - D_bas) / (2*H));
garde_sup_marques = 2;

//text
str_text = "P C  S t  E x  2 0 2 1";
font_text = "Share Tech Mono:style=Regular";
size_text = 5.5;


module ext(){
	//forme générale avec trou supérieur
	difference(){
		cylinder(d1=D_bas, d2=D_haut, h=H);
		translate([0,0,H-H_int]) cylinder(d=D_int, h=H_int+0.1);
	}
	//cylindre inférieur
	translate([0,0,-H_dessous]) cylinder(d=D_dessous, h=H_dessous+0.1);
	//marques: petites barres sur le pourtour
	if (marques){
		for(i=[0:n_marques-1]) rotate([0,0,i*360/n_marques]) translate([(D_haut+D_bas)/4,0,H/2]) rotate([0,angle_marques,0]) hull(){
			translate([0,0,H/2-1-garde_sup_marques]) sphere(d=2);
			translate([0,0,-H/2+1]) sphere(d=2);
		}
	}
	else{ //text
		text_on_cylinder(str_text,[0,0,-1],font=font_text, size=size_text,r1=D_bas/2, r2=D_haut/2,h=H, updown=-3);
	}
}

//ajout du filetage à la forme ext
difference(){
	ext();
	translate([0,0,-H_dessous+0.6]) tap(type_filetage, turns=4, tol=tol_filetage, fn=$fn);
}
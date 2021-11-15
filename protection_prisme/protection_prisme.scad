/*************************************

Protection de prisme optique en TPU
Impression en TPU 95A (20% de remplissage)

Ourida Smahi / Olivier Boesch
Lycée Saint Exupéry

**************************************/

$fn = 100;          // finesse de rendu (nb de segments par cercle)

a = 37.5;           //mm - arete du prisme
h = a * sqrt(3) /2; //mm - hauteur du relative à l'arète
ep = 4;             //mm - épaisseur de matière
rayon_arrondi = 3;  //mm - rayon de l'arrondi extérieur
h_prisme = 45;      //mm - hauteur du prisme
eps = 0.01;         //mm - décalage pour découpe (preview seulement)

//dessin des faces supérieures et inférieures du prisme
module triangle(){
	polygon([[-a/2,-h/2],[a/2,-h/2],[0,h/2]]);
}

//dessin du prisme
module prisme(){
	color("Gray", 0.5) linear_extrude(h_prisme) triangle();
}

//dessin d'une protection
module protection(){
	difference(){
		linear_extrude(2*ep) offset(r=rayon_arrondi) offset(delta = ep-rayon_arrondi) triangle();
		translate([0,0,-eps]) linear_extrude(ep+eps)triangle();
	}
}


//dessin total en preview
if($preview){
	color("orange") translate([0,0,ep]) rotate([0,180,0]) protection();
	prisme();
	color("orange") translate([0,0,h_prisme-ep]) protection();
}
//dessin en fabrication (render)
else{
	translate([0,0,2*ep]) rotate([0,180,0]) protection();
}

/*

	Palan

*/

$fn=150;

//libraries
use <MCAD/bearing.scad> // roulements à billes
use <MCAD/nuts_and_bolts.scad> //vis et écrous

tolerance_decoupe = 0.1; //mm - tolerance pour les differences (uniquement valable pour la preview)

//corde
diametre_corde = 6+0.3; //mm - diametre de la corde

//roulement
modele_roulement = 608; //modele de roulement (608 : skate standard)
dimensions_roulement = bearingDimensions(model=modele_roulement); //mm - dimensions du roulement [diamètre interieur, diamètre exterieur, epaisseur]

echo("roulement:", dimensions_roulement); 

//axe (boulon)
longueur_axe=40; //mm
diametre_axe=6; //mm
hauteur_ecrou = 4; //mm
tolerance_axe = 0.3; //mm

//poulie
ep_poulie = 1.5; //mm - épaisseur de matière mini entre roulement et corde
hauteur_poulie = max(dimensions_roulement[2], diametre_corde+ep_poulie); //mm
tolerance_hauteur_poulie = 0.5; //mm
tolerance_diametre_poulie = 0; //mm - écart avec le roulement
ep_inter_poulies = 3; //mm - épaisseur de matière entre deux poulies
decalage_poulies = hauteur_poulie + 2* tolerance_hauteur_poulie + ep_inter_poulies;

//palan
n_poulies = 3; //nombre de poulies
tolerance_logement_poulie = 4; //mm - espace entre corde et palan (vertical)
ep_max_palan = 4; //mm - épaisseur min de matière extérieure du palan
diametre_passage_poulie = dimensions_roulement[1] + ep_poulie*2 + diametre_corde*2 + tolerance_logement_poulie*2; //mm
hauteur_passage_poulie = hauteur_poulie + 2* tolerance_hauteur_poulie; //mm
diametre_horizontal = dimensions_roulement[1]+ep_poulie*2+diametre_corde; //mm
diametre_vertical = dimensions_roulement[1] + (ep_poulie + diametre_corde + tolerance_logement_poulie)*2 + ep_max_palan*2; //mm
hauteur_palan = (n_poulies * decalage_poulies) + 2*ep_max_palan; //mm
accroche_basse = true; //doit-on ajouter une deuxième accroche ?

echo("vis:", longueur_axe, "palan:", hauteur_palan);


//profil de la poulie
module profil_poulie(){
	translate([(diametre_corde/2+ep_poulie),0]) difference(){
		translate([-(diametre_corde/2+ep_poulie)/2,0]) square([diametre_corde/2+ep_poulie,hauteur_poulie],center=true);
		translate([0,0]) scale([1,1.5]) circle(d = diametre_corde);
	}
}

//poulie
module poulie(){
	rotate_extrude() translate([dimensions_roulement[1]/2 + tolerance_diametre_poulie,0]) profil_poulie();
	if($preview) bearing(model=modele_roulement);
}

//passage pour la poulie dans le roulement
module passage_poulie(){
	cylinder(d=diametre_passage_poulie, h = hauteur_passage_poulie, center=true);
}

//liaison roulement/axe
module adaptateur_poulie_axe(){
	difference(){
		cylinder(d=dimensions_roulement[0], h=hauteur_poulie+ 2* tolerance_hauteur_poulie, center=true);
		cylinder(d=diametre_axe+tolerance_axe, h=hauteur_poulie+ 2* tolerance_hauteur_poulie+2*tolerance_decoupe, center=true);
	}
}

//accroche du palan
module accroche_palan(){
	translate([diametre_vertical/2,0,0])rotate([90,0,0]) difference(){
		cylinder(d=hauteur_palan, h=ep_max_palan,center=true);
		translate([hauteur_palan/2-(diametre_corde *1.3)/2-ep_max_palan,0,0]) cylinder(d=diametre_corde *1.3, h = ep_max_palan++2*tolerance_decoupe, center=true);
	}
}

//le palan en lui-même
module corps_palan(accroche_basse=false){
	difference(){
		union(){
			scale([1, diametre_horizontal / diametre_vertical, 1]) cylinder(d=diametre_vertical, h = hauteur_palan, center=true);
			accroche_palan();
			if(accroche_basse) rotate([0,180,0]) accroche_palan();
		}
		translate([0,0,-(n_poulies-1)*decalage_poulies/2]) for(i=[0:n_poulies-1]) {
			translate([0,0,i*decalage_poulies]) passage_poulie();
		}
		translate([0,0,-hauteur_palan/2+4-tolerance_decoupe]) boltHole(diametre_axe,length=hauteur_palan, tolerance=tolerance_axe);
		translate([0,0,hauteur_palan/2-hauteur_ecrou/2+tolerance_decoupe]) nutHole(diametre_axe, tolerance=tolerance_axe);
	}
}

//dessin en preview avec axe et poulies
if($preview){
	translate([0,0,-(n_poulies-1)*decalage_poulies/2]) for(i=[0:n_poulies-1]) {
		translate([0,0,i*decalage_poulies]){
			adaptateur_poulie_axe();
			poulie();
		}
	}
	corps_palan(accroche_basse=accroche_basse);
	color("grey"){
		translate([0,0,-hauteur_palan/2+hauteur_ecrou]) boltHole(diametre_axe,length=longueur_axe);
		translate([0,0,hauteur_palan/2-hauteur_ecrou/2]) nutHole(diametre_axe);
	}
}

//dessin en rendu
else{
	translate([0,0,diametre_horizontal/2]) rotate([90,0,0]) corps_palan(accroche_basse=accroche_basse);
	for (i=[-(n_poulies-1)/2:1:(n_poulies-1)/2]){
		translate([i*diametre_passage_poulie,hauteur_palan/2 + 20 ,hauteur_poulie/2]) poulie();
		translate([i*diametre_passage_poulie,hauteur_palan/2 + 20 + 30,hauteur_poulie/2+tolerance_hauteur_poulie]) adaptateur_poulie_axe();
	}
}

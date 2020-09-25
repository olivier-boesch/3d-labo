/*
*
*   Porte tube pour electrolyseur
*
*   modèle paramétrique
*
*/

// dimensions ----------------
// -- cuve
epaisseur_plastique = 2.5;  //mm
diametre_exterieur_haut_cuve = 106;  //mm
diametre_exterieur_bas_cuve = 92;  //mm
hauteur_cuve = 87;  //mm
diametre_interieur_haut_cuve = diametre_exterieur_haut_cuve-2 * epaisseur_plastique;
diametre_interieur_bas_cuve = diametre_exterieur_bas_cuve - 2 * epaisseur_plastique;
// -- tube
diametre_tube = 14.4;  //mm
// -- pièce
depassement_piece = 2 * epaisseur_plastique;  //mm
longueur_piece = diametre_interieur_haut_cuve + depassement_piece;
largeur_piece = 1.5 * diametre_tube;
epaisseur_piece = 5;  //mm
// -- ergots
hauteur_ergot = epaisseur_piece;  //mm
epaisseur_ergot = 5;  //mm
// -- tolérances
tolerance_tube = 1;  //mm
tolerance_ergot = 2;  //mm

//finesse (dégradée en preview)
$fn=$preview?40:200;

//piece
corps();
translate([0,0,epaisseur_piece]) ergos();
//installation en preview
if($preview) translate([0,0,epaisseur_piece/2]) color("grey", 0.6){
    cuve();
    translate([diametre_tube,0,hauteur_cuve-2]) tube();
    translate([-diametre_tube,0,hauteur_cuve-2]) tube();
}

//parties --------------------
module corps(){
    difference(){
        //corps plein
        intersection(){
            cube([longueur_piece,
                  largeur_piece,
                  epaisseur_piece], center=true);
            cylinder(d=longueur_piece,
                     h=epaisseur_piece, center=true);
        }
        //trou tubes
        hull(){
            translate([diametre_tube,0,0]) cylinder(d=diametre_tube + tolerance_tube, h=epaisseur_piece+0.2,center=true);
            translate([-diametre_tube,0,0]) cylinder(d=diametre_tube + tolerance_tube, h=epaisseur_piece+0.2,center=true);
        }
    }
}

module ergos(){
    intersection(){
        translate([0,0,-epaisseur_piece/2]) difference(){
            cylinder(d1=diametre_interieur_haut_cuve-tolerance_ergot,
                     d2=diametre_interieur_bas_cuve-tolerance_ergot,
                     h=hauteur_cuve);
            translate([0,0,-0.1]) cylinder(d1=diametre_interieur_haut_cuve-2*epaisseur_ergot-tolerance_ergot,
                                           d2=diametre_interieur_bas_cuve-2*epaisseur_ergot-tolerance_ergot,
                                           h=hauteur_cuve+0.2);
        }
        corps();
    }
}

module cuve(){
    //cuve
    difference(){
        cylinder(d1=diametre_exterieur_haut_cuve, d2=diametre_exterieur_bas_cuve,h=hauteur_cuve);
        translate([0,0,-0.1]) cylinder(d1=diametre_interieur_haut_cuve, d2=diametre_interieur_bas_cuve,h=hauteur_cuve+0.2);
    }
    translate([0,0,hauteur_cuve-epaisseur_plastique]) cylinder(d=diametre_interieur_bas_cuve,h=epaisseur_plastique);
}

module tube(h_tube=200){
    rotate([0,180,0]) cylinder(d=diametre_tube,h=h_tube);
}
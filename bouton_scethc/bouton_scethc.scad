/*

Bouton pour appareil de mesure de la résistance thermique
sciencéthic ref n°005027

reproduction modèle : Olivier Boesch

uniquement pour réparation, svp.

*/

// ------------ mesures

//bouton en général
d_bouton = 40; //mm - diametre extérieur
h_bouton = 15; //mm
ep_matiere_bouton = 1.5; //mm
p_texte = 0.6; //mm

//téton pour tourner
d_teton = 6; //mm
h_teton = 8; //mm

//tige filetée (partie interne)
h_tige = 21.28; //mm
d_tige = 6.1; //mm
p_trou = 19.4; //mm
ep_matiere_tige = 2.5; //mm

//trou pour vis de fixation
d_trou = 1.5; //mm
h_trou = 4; //mm = position à partir du bas du bouton

//-------- rendu

//finesse
$fn=200; //200 segments pour un cercle

//dessin du bouton en totalité
bouton_scethc(d_bouton, h_bouton, ep_matiere_bouton, p_texte, d_teton, h_teton, h_tige, d_tige, p_trou, ep_matiere_tige, d_trou, h_trou);

//--------parties

// corps creux
module corps(d_bouton, h_bouton, ep_matiere_bouton){
    difference(){
        cylinder(d= d_bouton, h = h_bouton, center= true);
        translate([0,0,-ep_matiere_bouton]) cylinder(d= d_bouton-2*ep_matiere_bouton, h = h_bouton, center= true);
    }
}

//test avec une vue en coupe
/*dim = max(d_bouton, h_bouton+h_tige+h_teton);
difference(){
    corps(d_bouton, h_bouton, ep_matiere_bouton);
    translate([0,dim/2,0]) cube(dim, center=true);
    }
*/

//téton pour rotation
module teton(d_teton, h_teton){
    cylinder(d= d_teton, h = h_teton, center= true);
}

//test integration teton
/*dim = max(d_bouton, h_bouton+h_tige+h_teton);
difference(){
    union(){
        corps(d_bouton, h_bouton, ep_matiere_bouton);
        translate([0,-d_bouton/2+d_teton/2+1,h_bouton/2+h_teton/2]) teton(d_teton, h_teton);
    }
    translate([dim/2,0,0]) cube(dim, center=true);
}*/

//axe de tige filetée interne
module axe_vis(d_tige, h_tige, ep_matiere_tige, p_trou, hole=false){
    if (hole == false){
        difference(){
            cylinder(d = d_tige + 2*ep_matiere_tige, h = h_tige, center=true);
            translate([0,0,p_trou/2 - h_tige/2]) cylinder(d = d_tige, h = h_tige, center=true);
        }
    }
    else{
        translate([0,0,p_trou/2 - h_tige/2]) cylinder(d = d_tige, h = h_tige, center=true);
    }
}

//test axe_vis
/*dim = max(d_bouton, h_bouton+h_tige+h_teton);
difference(){
    union(){
        corps(d_bouton, h_bouton, ep_matiere_bouton);
        translate([0,-d_bouton/2+d_teton/2+1,h_bouton/2+h_teton/2]) teton(d_teton, h_teton);
        #translate([0,0,-(h_tige-h_bouton)/2]) axe_vis(d_tige, h_tige, ep_matiere_tige);
    }
    translate([dim/2,0,0]) cube(dim, center=true);
    translate([0,0,-(h_tige-h_bouton)/2]) axe_vis(d_tige, h_tige, ep_matiere_tige,hole=true);
}*/

//trou pour vis de fixation
module trou_vis(d_trou, l_trou){
    rotate([0,90,0]) cylinder(d = d_trou, h = l_trou,center = true);
}

//test trou_vis
/*dim = max(d_bouton, h_bouton+h_tige+h_teton);
difference(){
    union(){
        corps(d_bouton, h_bouton, ep_matiere_bouton);
        translate([0,-d_bouton/2+d_teton/2+1,h_bouton/2+h_teton/2]) teton(d_teton, h_teton);
        translate([0,0,-(h_tige-h_bouton)/2]) axe_vis(d_tige, h_tige, ep_matiere_tige);
    }
    translate([dim/2,0,0]) cube(dim, center=true);
    #translate([0,0,-(h_tige-h_bouton)/2 - h_tige/2+h_trou]) trou_vis(d_trou, l_trou=d_tige + 2*ep_matiere_tige+2);
}*/

//texte central
module texte(txt, h_texte){
    linear_extrude(h_texte) text(txt, font="Futura Bk BT:style=Book", halign="center", valign="center", size=4);
    }
    
//symbole de flèche
module fleche(){
    points = [
                [-1,-2],
                [1,-2],
                [1,1],
                [0,2],
                [-1,1]
             ];
    linear_extrude(2) polygon(points);
}

//ensemble pour monter
module signe_haut(){
    translate([0,3,0]) fleche();
    translate([0,-3,0]) rotate([0,0,180]) fleche();
}

//ensemble pour descendre
module signe_bas(){
    translate([0,-3,0]) fleche();
    translate([0,3,0]) rotate([0,0,180]) fleche();
}

//bouton en totalité
module bouton_scethc(d_bouton, h_bouton, ep_matiere_bouton, p_texte, d_teton, h_teton, h_tige, d_tige, p_trou, ep_matiere_tige, d_trou, h_trou){
    difference(){
        union(){
            corps(d_bouton, h_bouton, ep_matiere_bouton);
            translate([0,-d_bouton/2+d_teton/2+1,h_bouton/2+h_teton/2]) teton(d_teton, h_teton);
            translate([0,0,-(h_tige-h_bouton)/2]) axe_vis(d_tige, h_tige, ep_matiere_tige,p_trou);
        }
        translate([0,0,-(h_tige-h_bouton)/2 - h_tige/2 + h_trou]) trou_vis(d_trou, l_trou=d_tige + 2*ep_matiere_tige+2);
        translate([0,0,h_bouton/2-p_texte]) texte("0 - 20 mm", 2);
        translate([d_bouton/2-4,0,h_bouton/2-p_texte]) signe_haut();
        translate([-d_bouton/2+4,0,h_bouton/2-p_texte]) signe_bas();
        translate([0,0,-(h_tige-h_bouton)/2]) axe_vis(d_tige, h_tige, ep_matiere_tige,p_trou,hole=true);
    }
}
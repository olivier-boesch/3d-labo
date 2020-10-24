/********************************************************
* Couvercle de calorimètre Jeulin
*
*   Olivier Boesch (c) 2020
*
*   v1 : version initiale
********************************************************/
use <ShortCuts.scad>

//------- plaque
// epaisseur (mm)
ep = 1; // [1:5]
//longueur (mm) sans arrondi avec prise ongle
L = 62.5; // [10:100]
//largeur (mm)
l = 47; // [10:100]
//texte sur la pièce
texte_titre = "St Ex";
taille_texte = l/4;
// ------ cylindre
//diamètre cylindre (mm)
d_cyl = 40; // [5:100]
//hauteur cylindre (mm)
h_cyl=10; // [5:50]
//eapisseur paroi cylindre (mm)
ep_cyl = 1; // [1:20]

//finnesse de rendu
$fn = 300;

module plaque(L,l,ep,d_ongle=15){
    d_cylinder = 2 * sqrt(pow(l/2,2) + pow(L-l/2,2));
    angle_cylinder = atan(l/(2*L-l));
    difference(){
        union(){
            //plaque
            translate([0,-l/2,0]) cube([L-l/2,l,ep]);
            //arrondi largeur
            cylinder(d=l,h=ep);
            //arrondi faible (pour ongle)
            translate([0,0,ep/2]) cylinder_sector(d = d_cylinder, w1=-angle_cylinder, w2=angle_cylinder,h=ep);
        }
        //piece pour ongle
        translate([d_cylinder/2+d_ongle/4,0,ep/2])cylinder(d=d_ongle,h=ep/2+1);
    }
}

module bouchon(d=d_cyl, h=h_cyl, ep=ep_cyl){
    translate([0,0,h_cyl/2]) difference(){
        cylinder(d=d, h=h_cyl,center=true);
        cylinder(d=d-2*ep_cyl, h=h_cyl+2,center=true);
    }
}

module couvercle_calorimetre(){
    difference(){
        union(){
            plaque(L=L,l=l,ep=ep);
            translate([0,0,ep]) bouchon();
        }
        translate([L/2,0,ep+1]) rotate([180,0,-90]) linear_extrude(ep+2) text(texte_titre, size=taille_texte,halign="center", valign="center", font="Aero Matics Stencil:style=Bold");
    }
}

couvercle_calorimetre();
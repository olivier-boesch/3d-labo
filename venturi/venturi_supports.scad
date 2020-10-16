/*

    Etude de l'effet venturi : Supports
    
    Olivier Boesch (c) 2020

*/

//ecrous et vis
include <MCAD/nuts_and_bolts.scad>

//tube
d_ext = 80; //mm - diamètre extérieur du tube
ep_matiere_tube = 4; // mm - epaisseur de matière autour du tube

//profilé (section carrée)
a_ext_profil = 10;
ep_profil = 0.9;
h_connecteur = 15;
ep_matiere_profil = 4; // mm - epaisseur de matière autour du profilé

//connecteur
l = a_ext_profil+2*ep_matiere_profil;  //mm - largeur du connecteur
retrait = 2; // mm - espace entre les fixations du tube

//fixations
vis = 3; //mm - diametre de la vis

//fn - finesse
$fn = 300;

module connecteur_profil_tube(d_tube, a_ext_profil, ep_matiere_profil, h_connecteur){
    translate([0,0,-d_tube/2-h_connecteur/2+0.1]){
        difference(){
            translate([0,0,h_connecteur/2]) cube([a_ext_profil+2*ep_matiere_profil,a_ext_profil+2*ep_matiere_profil,h_connecteur*2],center=true);
            translate([0,0,d_tube/2+h_connecteur/2]) rotate([0,90,0]) cylinder(d = d_tube, h = a_ext_profil+2*ep_matiere_profil + 0.2, center=true);
            translate([0,0,-0.1]) cube([a_ext_profil,a_ext_profil,h_connecteur+0.2],center =true);
        }
    }
}

module fixation_vis(vis, ep_matiere_tube, l){
    translate([0,0,(ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2]) difference(){
        cube([l,ep_matiere_tube*2+METRIC_NUT_THICKNESS[vis],ep_matiere_tube+METRIC_NUT_THICKNESS[vis]],center=true);
        translate([0,0,ep_matiere_tube+0.1]) boltHole(vis, tolerance = +0.01);
        cylinder(d = COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS[vis] + 0.2, h= ep_matiere_tube+METRIC_NUT_THICKNESS[vis] + 0.2, center=true);
    }
}

module fixation_ecrou(vis, ep_matiere_tube=4,l=12){
    translate([0,0,(ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2]) difference(){
        cube([l,ep_matiere_tube*2+METRIC_NUT_THICKNESS[vis],ep_matiere_tube+METRIC_NUT_THICKNESS[vis]],center=true);
        translate([0,0,ep_matiere_tube-METRIC_NUT_THICKNESS[vis]]) nutHole(vis, tolerance = +0.01);
        cylinder(d = COURSE_METRIC_BOLT_MAJOR_THREAD_DIAMETERS[vis] + 0.2, h= ep_matiere_tube+METRIC_NUT_THICKNESS[vis] + 0.2, center=true);
    }
}

module demi_cylindre(d_ext, ep_matiere_tube, l, retrait){
    difference(){
        rotate([0,90,0]) difference(){
            cylinder(d = d_ext+2*ep_matiere_tube, h = l, center=true);
            cylinder(d = d_ext, h = l+0.2, center=true);
        }
        translate([0,0,d_ext/2+ep_matiere_tube+0.1-retrait]) cube([l+0.4, d_ext+2*ep_matiere_tube+0.2,d_ext+2*ep_matiere_tube+0.2],center=true);
    }
}

module connecteur_profil_plat(a_ext_profil, ep_matiere_profil, h_connecteur, vis){
    translate([0,0,h_connecteur/2+ep_matiere_profil/2]) rotate([0,180,0]) difference(){
        cube([a_ext_profil+2*ep_matiere_profil,a_ext_profil+2*ep_matiere_profil,h_connecteur+ep_matiere_profil],center=true);
        translate([0,0,-0.1-ep_matiere_profil]) cube([a_ext_profil,a_ext_profil,h_connecteur+0.2],center =true);
    }
    difference(){
        translate([0,0,ep_matiere_profil/2]) cube([a_ext_profil*4,a_ext_profil*4,ep_matiere_profil],center=true);
        translate([a_ext_profil*1.3,a_ext_profil*1.3,0]) cylinder(d=vis, h=ep_matiere_profil*3, center=true);
        translate([-a_ext_profil*1.3,a_ext_profil*1.3,0]) cylinder(d=vis, h=ep_matiere_profil*3, center=true);
        translate([a_ext_profil*1.3,-a_ext_profil*1.3,0]) cylinder(d=vis, h=ep_matiere_profil*3, center=true);
        translate([-a_ext_profil*1.3,-a_ext_profil*1.3,0]) cylinder(d=vis, h=ep_matiere_profil*3, center=true);
    }
}

// support de tube (partie basse)
module support_tube_bas(d_ext, a_ext_profil, ep_profil,h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis){
    demi_cylindre(d_ext, ep_matiere_tube, l, retrait/2);
    connecteur_profil_tube(d_ext+2*ep_matiere_tube,a_ext_profil, ep_matiere_profil, h_connecteur);
    translate([0,-d_ext/2-(3*ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2,-retrait/2]) rotate([180, 0, 0]) fixation_vis(vis, ep_matiere_tube,l);
    translate([0,+d_ext/2+(3*ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2,-retrait/2]) rotate([180, 0, 0]) fixation_vis(vis, ep_matiere_tube,l);
}

// support de tube (partie haute)
module support_tube_haut(d_ext, a_ext_profil, ep_profil,h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis){
    rotate([180, 0, 0]) demi_cylindre(d_ext, ep_matiere_tube, l, retrait/2);
    translate([0,-d_ext/2-(3*ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2,retrait/2]) fixation_ecrou(vis, ep_matiere_tube,l);
    translate([0,+d_ext/2+(3*ep_matiere_tube+METRIC_NUT_THICKNESS[vis])/2,retrait/2]) fixation_ecrou(vis, ep_matiere_tube,l);
}

if($preview){
    support_tube_bas(d_ext, a_ext_profil, ep_profil, h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis);
    support_tube_haut(d_ext, a_ext_profil, ep_profil,h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis);
    color("grey", 0.3){
        translate([0,0,-d_ext-h_connecteur/2-ep_matiere_tube]) cube([a_ext_profil,a_ext_profil,50], center=true);
        translate([-l/2-10-25,0,0]) rotate([0,90,0]) cylinder(d = d_ext, h= 50, center=true);
        translate([l/2+10+25,0,0]) rotate([0,90,0]) cylinder(d = d_ext, h= 50, center=true);
    }
    translate([0,0,-d_ext-h_connecteur/2-ep_matiere_tube-50]) connecteur_profil_plat(a_ext_profil, ep_matiere_profil, h_connecteur, vis);
}
else{
    rotate([0,90,0]) {
        support_tube_bas(d_ext, a_ext_profil, ep_profil, h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis);
        support_tube_haut(d_ext, a_ext_profil, ep_profil,h_connecteur, l, ep_matiere_tube, ep_matiere_profil, retrait, vis);
    }
    translate([0,-d_ext-2*a_ext_profil,-l/2]) connecteur_profil_plat(a_ext_profil, ep_matiere_profil, h_connecteur, vis);
}

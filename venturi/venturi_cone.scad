/*

    Section conique pour étude de l'effet venturi
    Conçu pour tubes PVC
    
    Olivier Boesch (c) 2020

*/

// grande section
ep_g = 4; //mm - epaisseur du connecteur
d_ext_g = 80; //mm - diamètre extérieur du tube
d_int_g = 76; //mm - diamètre intérieur du tube
l_g = 10;  //mm - longueur du connecteur

// petite section
ep_p = 4; //mm - epaisseur du connecteur
d_ext_p = 40; //mm - diamètre extérieur du tube
d_int_p = 35; //mm - diamètre intérieur du tube
l_p = 10; //mm - longueur du connecteur

//section conique
l = 80; //mm - longueur de la section conique

//fn - finesse
$fn = 300;

// connecteur de tube
module connecteur(d_ext, d_int,l){
    rotate([0,90,0]) difference(){
        cylinder(d = d_ext, h = l, center=true);
        cylinder(d = d_int, h = l+2, center=true);
    }
}

// cone
module cone(d_beg_ext, d_beg_int, d_end_ext, d_end_int, l){
    rotate([0,90,0]) difference(){
        cylinder(d1 = d_beg_ext, d2 = d_end_ext, h = l, center=true);
        cylinder(d1 = d_beg_int, d2 = d_end_int, h = l+0.2, center=true);
    }
}

// piece complete
module venturi(d_ext_g, d_int_g, ep_g, l_g, d_ext_p, d_int_p, ep_p, l_p, l){
    translate([-l_g/2-l/2,0,0]) connecteur(d_ext_g+ep_g, d_ext_g,l_g);
    cone(d_ext_g+ep_g, d_int_g, d_ext_p+ep_p, d_int_p, l);
    translate([l_p/2+l/2,0,0]) connecteur(d_ext_p+ep_p, d_ext_p,l_p);
}

// tube (pour preview)
module tube(d_ext, d_int, l){
    rotate([0,90,0]) difference(){
        cylinder(d = d_ext, h = l, center=true);
        cylinder(d = d_int, h = l+0.2, center=true);
    }
}


// dessin de la piece :
// avec tube et en coupe en preview
// piece seule en rendu
if($preview){ //preview
    difference(){
        union(){
            venturi(d_ext_g, d_int_g, ep_g, l_g, d_ext_p, d_int_p, ep_p, l_p, l);
            color("red", 0.3){
                translate([-l/2-28,0,0]) tube(d_ext_g, d_int_g, 30);
                translate([+l/2+28,0,0]) tube(d_ext_p, d_int_p, 30);
            }
        }
        a_cube = 200;
        translate([0,a_cube/2,0]) cube(a_cube, center=true);
    }
}
else{ // rendu
    venturi(d_ext_g, d_int_g, ep_g, l_g, d_ext_p, d_int_p, ep_p, l_p, l);
}
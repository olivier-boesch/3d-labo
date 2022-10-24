/*

	tuyau sonore
	olivier boesch (c) 2022
	
	documents:
	Correction de Aristide Cavaillé-Coll - 1860
		longueur théorique - 2*largeur de la section
		https://organ-au-logis.pagesperso-orange.fr/Pages/CavailleTuyau.htm
		https://gallica.bnf.fr/ark:/12148/bpt6k3007r/f178.item.zoom#

*/

/******************** EXEMPLES *********************/

//essai : gamme do min naturelle (mib, lab, sib) lab3-do5
//tableau_notes = [-4,-2,0,2,3,5,7,8,10,12];
//essai : gamme do maj la3-do5
tableau_notes = [-3,-1,0,2,4,5,7,9,11,12];

//exemple direct
//tuyau(f=440, type_texte="c", texte_custom="référence (la3)");

//exemple en détaché
for(i=[0:len(tableau_notes) - 1]){
	let(f = note_vers_frequence(tableau_notes[i])) translate([0,i*2*s,0]) tuyau(f, type_texte="c", texte_custom=note_vers_nom(tableau_notes[i]));
	echo(str(note_vers_nom(tableau_notes[i]), "=", note_vers_frequence(tableau_notes[i]), "Hz"));
}//*/

//exemple en flute de pan
/*for(i=[0:len(tableau_notes) - 1]){
	let(f = note_vers_frequence(tableau_notes[i])) translate([0,0,i*(s+ep_mat)]) tuyau(f, type_texte="c", texte_custom=note_vers_nom(tableau_notes[i]));
	echo(note_vers_nom(tableau_notes[i]));
}//*/

// vue en coupe (pour dessin et export svg)
//coupe_tuyau(f=880);

/******************* PARAMETRES *******************/

//---- rendu
$fn = $preview?40:120; // finesse de rendu (nombre de segments pour un cercle)
eps = 0.1; //mm - difference pour les découpes
taille_texte = 5; //mm - taille du texte
police_texte = "Share Tech"; //police du texte

//---- matière
s = 10; //mm - section tube
ep_mat = 1.5; //mm - epaisseur matière

//---- sifflet
L_sifflet = 25; //mm - longueur totale du sifflet
L_ouverture = 10; //mm - longueur de l'ouverture (trou + biseau)
h_entree = 2; //mm - hauteur de l'entrée
d_sifflet = 0.8; //mm - arrondi du biseau du sifflet (idéalement 2*diametre de la buse de l'imprimante)

//---- frequences et notes
ecart_demi_ton = pow(2, 1/12); //coef multiplicateur entre deux demi-tons
la3 = 440;
do4 = la3 * pow(ecart_demi_ton, 3); //Hz - fréquence du do 4

// calcul de la fréquence à partir de l'écart au do4
function note_vers_frequence(note) = do4 * pow(ecart_demi_ton, note);

//notes
notes = ["do", "do#/réb", "ré", "ré#/mib", "mi", "fa", "fa#/solb", "sol", "sol#/lab", "la", "la#/sib", "si"];

//nom de la note
function note_vers_nom(note) = str(notes[note % 12>=0?note%12:12 + note%12], floor(note/12)+4);

//---- environnement
T = 25; //°C - température

//---- calcul de la vitesse du son
// source : https://fr.wikipedia.org/wiki/Vitesse_du_son#Formules_approch%C3%A9es_pour_l'air
gamma = 1.4;
R = 287;
function vitesse_son(T = 0) = sqrt(gamma * R * (T + 273.15));

echo(str("Cson=", vitesse_son(T), "m/s"));

//---- longueur acoustique (mm)
function l_acoustique(f=440) = vitesse_son(T) / (4 * f) * 1000;

/******************* MODULES ********************/

//---- tuyau sonore semi-ouvert simple (sans sifflet)
// f: fréquence du tuyau en Hz
// type_texte: texte affiché sur la tranche (l -> l_affichage, f-> fréquence, c-> texte_custom)
// texte_custom: texte arbitraire à afficher (avec type_texte = 'c')
module tuyau_simple(f=870, type_texte = "l", texte_custom=""){
	//l: longueur effective du tuyau
	// Correction de Aristide Cavaillé-Coll - 1860
	// longueur théorique - 2*largeur de la section
	// https://organ-au-logis.pagesperso-orange.fr/Pages/CavailleTuyau.htm
	// https://gallica.bnf.fr/ark:/12148/bpt6k3007r/f178.item.zoom#
	// et correction due à l'emplacement du biseau (L_ouverture/2)
	l = l_acoustique(f) - 2 * s - L_ouverture/2;
	// longueur affichée
	l_affichage = l_acoustique(f); //valeur affichée sur la tranche (longueur acoustique théorique)
	translate([-l/2-ep_mat/2, 0, 0]) difference(){
		//extérieur
		cube([l+ep_mat, s+2*ep_mat, s+2*ep_mat], center=true);
		//intérieur (trou)
		translate([ep_mat, 0, 0]) cube([l+ep_mat, s, s], center=true);
		//texte
		translate([0, -s/2 - ep_mat, 0]) rotate([0,180,0]) rotate([90,0,0]) linear_extrude(ep_mat, center=true, convexity=20){
			if(type_texte =="f") text(str(round(f * 10) / 10, "Hz"), size=taille_texte, halign="center", valign="center", font=police_texte);
			if(type_texte =="l") text(str(round(l_affichage * 10) / 10, "mm"), size=taille_texte, halign="center", valign="center", font=police_texte);
			if(type_texte =="c") text(texte_custom, size=taille_texte, halign="center", valign="center", font=police_texte);
		}
	}
}

//profil du sifflet en 2D (sans détail en cas de paroi)
// paroi: affichage pour aproi (true -> sans détails internes)
module profil_sifflet(paroi = false){
	difference(){
		//corps
		translate([L_sifflet/2, 0]) square([L_sifflet, s + 2 * ep_mat], center=true);
		if(!paroi){
			//entrée
			translate([L_sifflet/2,-s / 2 + h_entree / 2]) square([L_sifflet + eps, h_entree], center=true);
			//intérieur (proche tuyau)
			translate([L_ouverture/2,-ep_mat/2 - eps/2]) square([L_ouverture, s + ep_mat + eps], center=true);
		}
		//arrondi
		translate([L_ouverture + s - h_entree+ep_mat, s/2 + ep_mat]) circle(r=s - h_entree);
		//espace sous l'entrée
		translate([L_sifflet - (L_sifflet - (L_ouverture + s - h_entree + ep_mat + eps))/2 , ep_mat + h_entree / 2 + eps/2]) square([L_sifflet - (L_ouverture + s - h_entree + 0.5*ep_mat + eps), s - h_entree + eps], center=true);
	}
	//biseau
	if(!paroi) hull(){
		translate([L_ouverture/2 - d_sifflet/2, -s/2 - d_sifflet/2]) circle(d=d_sifflet);
		translate([0, -s/2 - ep_mat/2]) square([eps, ep_mat], center=true);
	}
}

//sifflet (extrusion avec et sans parois)
module sifflet(){
	translate([0,0,-s/2 - ep_mat/2]) linear_extrude(ep_mat, center=true) profil_sifflet(paroi=true); //paroi basse
	linear_extrude(s, center=true) profil_sifflet(); //corps
	translate([0,0,s/2 + ep_mat/2]) linear_extrude(ep_mat, center=true) profil_sifflet(paroi=true); //paroi haure
}

//projection de coupe en 2D du tuyau complet
//f : fréquence du tuyau en Hz
module coupe_tuyau(f=440){
	rotate([180,0,0]) projection(cut=true){
		sifflet();
		tuyau_simple(f=f, type_texte = "");
	}
}

//tuyau complet (tuyau simple + sifflet)
// f: fréquence du tuyau en Hz
// type_texte: texte affiché sur la tranche (l -> l_affichage, f-> fréquence, c-> texte_custom)
// texte_custom: texte arbitraire à afficher (avec type_texte = 'c')
module tuyau(f=440, type_texte="f", texte_custom=""){
	sifflet();
	tuyau_simple(f=f, type_texte=type_texte, texte_custom=texte_custom);
}

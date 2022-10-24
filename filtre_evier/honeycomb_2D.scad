$fn=150;


module honeycomb_2D(L=10,l=10, rot=0, hole=5, ep=1){
	n_x = ceil(L/hole);
	n_y = ceil(l/hole);
	entraxe_y = hole;// +ep/2;
	entraxe_x = hole/2 + ep/2 + hole*sqrt(3)/6;
	
	rotate([0,0,rot]) translate([-L/2,-l/2]){
		for(i=[0:n_x]){
			for(j=[0:n_y]){
				translate([i*entraxe_x,j*entraxe_y+(i%2)*entraxe_y/2,0]) difference(){
					circle(d=hole+2*ep, $fn=6);
					circle(d=hole, $fn=6);
				}
			}
		}
	}
}

honeycomb_2D(L=40,l=40, rot=0,hole=10,ep=1);

/*linear_extrude(0) difference(){
	circle(d=48);
	circle(d=40);
}

linear_extrude(4){
	difference(){
		circle(d=35);
		circle(d=29);
	}
	intersection(){
		honeycomb_2D(L=40,l=40, rot=0,hole=10,ep=1);
		circle(d=30);
	}
}*/
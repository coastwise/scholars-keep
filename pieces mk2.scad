// bottom is increased by bevel on axis from centre to point
module triangle (h, r, b=0) {
    cylinder(h=h, r1=r+b, r2=r, $fn=3);
}

thickness = 2;

//rotate([0,0,-30]) triangle(thickness, tri_radius, 0);

tri_height = 25.4; // 1 inch
tri_width  = tri_height * 2 / sqrt(3);
tri_radius = tri_height * 2 / 3;

module side () {
    s = [tri_width*2, tri_height, thickness];
    translate([-tri_width,-tri_height+tri_radius,0]) cube(s);
}

module piece (data) {
    intersection_for(i=[0:2]) {
        if (data / pow(2,i) % 2 >= 1) {
            rotate([0,0,i*120]) side();
        }
    }
}

module pieces (pattern=[], index=0) {
    if (index < len(pattern)){
        piece(pattern[index]);
        rotate([0,0,-60]) translate([0, tri_radius, 0]) pieces(pattern, index+1);
     }
}

pacman = [5,5,5,7];
pieces(pacman);

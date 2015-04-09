// bottom is increased by bevel on axis from centre to point
module triangle (h, r, b=0) {
    cylinder(h=h, r1=r+b, r2=r, $fn=3);
}

thickness = 2;

//

tri_height = 25.4; // 1 inch
tri_width  = tri_height * 2 / sqrt(3);
tri_radius = tri_height * 2 / 3;

gap = 1; // between pieces

module side () {
    s = [tri_width*2, tri_height, thickness];
    translate([-tri_width,-tri_height+tri_radius,0]) cube(s);
}

module exterior_edge () {
    intersection () {
    translate([-tri_width/2,-tri_height+tri_radius+gap/2,0])
    cube([tri_width, thickness, thickness*2]);
        rotate([0,0,-30]) triangle(10, tri_radius-gap,0);
    }
}

module interior_edge () {
    intersection () {
    translate([-tri_width/2,-tri_height+tri_radius,0])
    cube([tri_width, thickness, thickness]);
        translate([0,-gap/2,0]) rotate([0,0,-30]) triangle(10, tri_radius-gap/2,0);
    }
}


module piece (data) {
    rotate([0,0,-30]) triangle(thickness-1, tri_radius-gap, 0);
    clockwise = data >= 0 ? 1 : -1;
    for(i=[0:2]) {
        rotate([0,0,i*120*clockwise])
        if (abs(data) / pow(2,i) % 2 >= 1) {
            exterior_edge();
        } else {
            interior_edge();
        }
    }
}

module pieces (pattern=[], index=0) {
    if (index < len(pattern)){
        clockwise = pattern[index] >= 0 ? 1 : -1;
        piece(pattern[index]);
        rotate([0,0,-60*clockwise]) translate([0, tri_radius, 0]) pieces(pattern, index+1);
     }
}

pacman = [5,4,4,6];
stick = [5,4,-4,6];
triforce = [5,0,6];

offset = [0,2*tri_width,0];

translate(-offset) pieces(triforce);
pieces(pacman);
translate(offset) pieces(stick);

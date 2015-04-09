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

module exterior_wall (thickness) {
    translate([-tri_width/2,-tri_height+tri_radius+gap/2,0])
    cube([tri_width, thickness, thickness*2]);
}

module interior_wall (thickness) {
    translate([-tri_width/2,-tri_height+tri_radius,0])
    cube([tri_width, thickness, thickness]);
}

module piece (data) {
    rotate([0,0,-30]) triangle(thickness-1, tri_radius-gap, 0);
    clockwise = data >= 0 ? 1 : -1;
    intersection () {
        // actual walls, unioned
        for(i=[0:2]) {
            rotate([0,0,i*120*clockwise])
            if (abs(data) / pow(2,i) % 2 >= 1) {
                exterior_wall(thickness);
            } else {
                interior_wall(thickness);
            }
        }
        
        // a bounding triangle for the whole piece
        // created by the intersection of "infinitely" thick walls
        intersection_for(i=[0:2]) {
            rotate([0,0,i*120*clockwise])
            if (abs(data) / pow(2,i) % 2 >= 1) {
                exterior_wall(tri_height);
            } else {
                interior_wall(tri_height);
            }
        }
    }
}

module pieces (pattern=[], index=0) {
    if (index < len(pattern)){
        if (len(pattern[index]) == undef) {
            clockwise = pattern[index] >= 0 ? 1 : -1;
            piece(pattern[index]);
            rotate([0,0,-60*clockwise]) translate([0, tri_radius, 0]) pieces(pattern, index+1);
        } else {
            pieces(pattern[index],0);
            rotate([0,0,60]) translate([0, tri_radius, 0]) pieces(pattern, index+1);
        }
     }
}

pacman = [5,4,4,6];
stick = [5,4,-4,6];
triforce = [5,[0,6],6];

foundation = [5,-4,[0,4,[0,-4,[0,6],4,6],-4,[0,6],4,6],6];

offset = [0,2*tri_width,0];

translate(-offset) pieces(triforce);
pieces(foundation);


// bottom is increased by bevel on axis from centre to point
module triangle (h, r, b=0) {
    cylinder(h=h, r1=r+b, r2=r, $fn=3);
}

tri_height = 100;
tri_width  = tri_height * 2 / sqrt(3);
tri_radius = tri_height * 2 / 3;

thickness = 5;
battlement = 5;

module crenellation (n, w, h) {
    step = w/(n+1);
    translate([-w/2,0,0]) {
        for (i = [1:n])
            translate([i*step,0,h/2])
            cube([5,6,h],center=true);
    }
} 

module piece () {
    difference() {
        triangle(10, tri_radius, 0);
        translate([0,0,battlement]) {
            triangle(battlement+1, tri_radius-5, 0);
            for (i = [0:2])
                rotate([0, 0, 90 + i*120])
                translate([0, tri_height/3, 1])
                crenellation(4, tri_width, battlement);
        }
    }
    translate([0,0,-battlement]) triangle(battlement, tri_radius-5, 0);
}

module pieces (n) {
    for (i = [0:n-1])
        translate([0, i*tri_width/2, 0])
        rotate([0, 0, i*180]) translate([-tri_height/6, 0, 0]) piece();
}

for (i = [0:3]) translate([i*tri_width*2,0,0]) pieces(i+1);

// bottom is increased by bevel on axis from centre to point
module triangle (h, r, b=0) {
    cylinder(h=h, r1=r+b, r2=r, $fn=3);
}

tri_height = 100;
tri_width  = tri_height * 2 / sqrt(3);
tri_radius = tri_height * 2 / 3;

thickness = 5;
battlement = 5;

module crenellation (n, w) {
    translate([-tri_radius/2,20,5])
    cube([30,10,10], center=true);        
    translate([-tri_radius/2,-20,5])
    cube([30,10,10], center=true);
} 

module piece () {
    difference() {
        triangle(10, tri_radius, 0);
        translate([0,0,battlement]) {
            triangle(battlement+1, tri_radius-5, 0);
            for (i = [0:2]) rotate([0,0,i*120]) crenellation(2, tri_width);
        }
    }
    translate([0,0,-battlement]) triangle(battlement, tri_radius-5, 0);
}

piece();

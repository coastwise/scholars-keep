// bottom is increased by bevel on axis from centre to point
module bevelled_triangle (h, w, b) {
	cylinder(h=h, r1=w+b, r2=w, $fn=3);
}

tri_height = 100;
tri_width  = tri_height * 2 / sqrt(3);
tri_radius = tri_height * 2 / 3;

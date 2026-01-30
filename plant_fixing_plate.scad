$fn=50;
linear_extrude(2) {
difference() {
    offset(r=+3) offset(delta=-3) square([36, 8]);
    translate([9, 4]) circle(2);
    translate([27,4]) circle(2);
}
}
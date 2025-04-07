use <main.scad>

$fa = 0.5;
$fs = 0.5;

if (0) {

    difference() {
        intersection() {
            bottom();
            //translate([65, 20, -20]) cube([18, 70, 300]);
            translate([85, -5, -20]) cube([11, 16, 7]);
        }
    }
} else {

    bottom();
}
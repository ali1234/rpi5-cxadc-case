use <main.scad>

$fa = 0.5;
$fs = 0.5;

difference() {
    intersection() {
        translate([0, 110, 19]) rotate([180, 0, 0]) top();
        //translate([30.9, 0]) cube([22.2, 150, 50]); 
    }
    //translate([0, 0, 8]) cube(1000);
}




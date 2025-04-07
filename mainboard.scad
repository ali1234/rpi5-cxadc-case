use <utils.scad>

//49, 58

$fs = 0.1;
$fa = 0.1;


mainboard_hole_spacing = [73, 78];
pi_hole_spacing = [49, 58];


module mirrorkeep(m) {
    mirror(m) children();
    children();
}

module quad() {
    mirrorkeep([0, 1]) mirrorkeep([1, 0]) children();
}


module mainboard_mounting() {
    translate([0, mainboard_hole_spacing[1]]) children();
    translate([0, mainboard_hole_spacing[1] - pi_hole_spacing[1]]) children();

    translate([pi_hole_spacing[0], mainboard_hole_spacing[1]]) children();
    translate([pi_hole_spacing[0], mainboard_hole_spacing[1] - pi_hole_spacing[1]]) children();

    translate([mainboard_hole_spacing[0], mainboard_hole_spacing[1]]) children();
    translate([mainboard_hole_spacing[0], 0]) children();
}

module mainboard(r=3.5, height=1.2) {
    linear_extrude(height=height) difference() {
        offset(r) square(mainboard_hole_spacing);
        mainboard_mounting() circle(d=2.4);
    }
    translate([0, 0, 0.395]) {
        translate([1+mainboard_hole_spacing[0]/2, 71.5, 0]) {
            intersection() {
                hull() {
                    quad() translate([6.5, 3]) sphere(2.4);
                }
                linear_extrude(height=10, center=true) offset(2.05) offset(-2) square([17,10], center=true) ;
            }
        }
        translate([mainboard_hole_spacing[0]-12.5, 25, -2]) {
            hull() {
                mirrorkeep([0, 1]) translate([0, 4]) cylinder(d=8, h=5);
            }
        }
    }
}

module mainboard_x(r=3.5, height=3) {
    translate([mainboard_hole_spacing[0]-12.5, 25, 0.1]) {
        difference() {
            hull() {
                mirrorkeep([0, 1]) translate([0, 4]) cylinder(d=10.5, h=2.91);
            }
            translate([2,3])rotate(180+45) cube(100);
        }
    }
}


module rpi() {
    color("red") translate([15.6, 39, 13.9]) rotate(-90) scale(25.4) import("RaspberryPi5.stl");
}


module rpi_cutouts() {
    translate([0, 0, 1]) {
        translate([6.7, 0, 14.6]) cube([16.2, 30.2, 14], center=true);
        translate([25.6, 0, 16.4]) cube([14.2, 21.2, 16], center=true);
        translate([43.5, 0, 16.4]) cube([14.2, 21.2, 16], center=true);

        translate([0, 0, 9.6]) {
            translate([-4, 70.5, 0]) cube([20, 10, 4.6], center=true);
            translate([-4, 55.75, 0]) cube([20, 8.5, 4.6], center=true);
            translate([-4, 42.5, 0]) cube([20, 8.5, 4.6], center=true);
        }
    }
/*
    translate([-10.02, 70.3, 9.35]) cube([10, 9.8+3.9, 3.6+2.6], center=true);
    translate([-10.02, 55.8, 9.35]) cube([10, 7.6+3.9, 3.6+2.6], center=true);
    translate([-10.02, 42.3, 9.35]) cube([10, 7.6+3.9, 3.6+2.6], center=true);
    */
    
}


mainboard();
//rpi_cutouts();

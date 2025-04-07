
$fs = 0.1;
$fa = 0.1;

module cxadc_mounting() {
    rotate([0, 180, 0])  mirror([0, 0, 1]) {
        translate([3, 4.5]) children();
        translate([53, 4.5]) children();
        translate([73.5, 55.5]) {
            translate([0, 15]) children();
            translate([0, -19]) rotate(180) children();
        }
    }
}


module cxadc_cutout_pos() {
    translate([-2, 0, 6.8]) {
        translate([13.5, 0, 0]) children(0);
        translate([13+15.9, 0, 0]) children(0);
        translate([13+15.9+15.9, 0, 0]) children(1);
    }
}


module cxadc_board() {
    rotate([0, 180, 0]) {
        color("green") mirror([0, 0, 1]) linear_extrude(height=1.6) difference() {
            union() {
                square([64, 100]);
                translate([74.5, 54]) square([11, 41], center=true);
            }
            translate([61, -1]) square(20);
            translate([53, 15]) square(18);
            translate([53, 65]) square([15, 50]);
            translate([55, 42]) hull() {
                circle(d=4);
                translate([7, 0]) circle(d=4);
            }
            translate([57, 56]) hull() {
                circle(d=2);
                translate([10, 0]) circle(d=2);
            }
            translate([60, 30]) square([9, 11]);
            rotate([0, 180, 0]) cxadc_mounting() circle(d=3);
        }
        
        
         cxadc_cutout_pos() {
            translate([0, 12, 0]) union() {
                color("yellow") cube(10, center=true);
                translate([0, -9, 0]) rotate([90, 0, 0]) {
                    color("lightgrey") difference() {
                        cylinder(d=7, h=8, center=true);
                        cylinder(d=5, h=11, center=true);
                    }
                    color("yellow") difference() {
                        cylinder(d=5.5, h=8.1, center=true);
                        cylinder(d=3.4, h=11, center=true);
                    }
                }
            }
            rotate([90, 0, 0]) {
                color("grey") {
                    translate([0, 0, -5]) cube([11, 10, 10], center=true);
                }
                color("lightgrey") difference() {
                    cylinder(d=9, h=2, center=true);
                    cylinder(d=8, h=3, center=true);               
                }
            }
        }
        color("black") translate([64.5, 54.5]) cube([9, 24, 8], center=true);
    }
    
}


module cxadc_cutouts() {
    color("lightgrey") rotate([0, 180, 0]) cxadc_cutout_pos() {
        rotate([90, 0, 0]) cylinder(d=10.5, h=20, center=true);
        rotate([90, 0, 0]) cylinder(d=12, h=20, center=true);
    }
}


cxadc_board();
//cxadc_cutouts();

$fs = 0.1;
$fa = 0.1;

module port_mounting() {
    translate([3.4, 17]) children();
    translate([21.6, 17]) children();
}


module port_cutout_pos() {
    translate([11.5, 6, 7.75]) children();
}


module port_board() {
    color("green") linear_extrude(height=1.6) difference() {
        offset(3) offset(-3) square([25, 20]);
        port_mounting() circle(d=3);
    }
    port_cutout_pos() {
        color("yellow") cube(12, center=true);
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
}

module port_cutouts() {
    port_cutout_pos() rotate([90, 0, 0]) cylinder(d=10.5, h=30);
}


port_board();
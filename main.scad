$fs = 0.5;
$fa = 0.5;


use <mainboard.scad>
use <cxadc.scad>
use <port.scad>
use <box.scad>
use <vent.scad>

case_x = 200;
case_y = 110;

bottom_height = 18.5;
top_height = 18.5; //total_height - bottom_height;

cx_height = bottom_height + 6.8;
mainboard_height = 3.01;
port_height = 10.75;

module cx_offset() {
    translate([case_x-13, 2.41, -bottom_height]) children();
}

m3_insert_d = 4;
m2_5_insert_d = 3.4;


module mainboard_offset() {
    translate([16.76, 6.01, -bottom_height]) children(); 
}

module port_offset() {
    translate([105.6, 8.01, -bottom_height]) children();
}


module case_insets() {
    translate([-case_x/2, 62.75-case_y/2]) square([21.5, 43], center=true);
    //translate([37-case_x/2, case_y/2]) square([28, 30.9], center=true);
}


module bottom() {


    difference() {
        union() {
            box_bottom([case_x, case_y], 7, [3, 2], bottom_height, thickness=1.4, wall=2)
                case_insets();
            mainboard_offset() {
                mainboard_mounting() cylinder(d=8, h=mainboard_height-0.01);
                mainboard_x();
            }
            /*
            translate([0, 0, 0.1-bottom_height]) linear_extrude(height=1.55) offset(0.15) {
                translate([36.5, 97.5]) text("RPi-CXADC", size=4, valign="center", halign="center");
                translate([78.75, 97.5]) text("v1.0", size=4, valign="center", halign="center");
                translate([121, 97.5]) text("Ali1234", size=4, valign="center", halign="center");
                translate([163.25, 97.5]) text("2024", size=4, valign="center", halign="center");
            }
            */
            intersection() {
                difference() {
                    cx_offset() cxadc_mounting() {
                        cylinder(d1=16, d2=6, h=8);
                        cylinder(d=6, h=cx_height);
                        translate([-3, -20]) cube([6, 20, bottom_height+2.75]);
                        //translate([-3, -5]) cube([6, 5, bottom_height+2.75]);
                    }
                    //#translate([90, 42, 0]) cube(28);
                }
                translate([1, 1, -bottom_height]) cube([case_x-11, case_y-2, bottom_height + top_height]);
            }
            port_offset() port_mounting() {
                cylinder(d1=16, d2=6, h=8);
                hull() {
                    cylinder(d=6, h=port_height);
                    translate([0, -10, 0]) cylinder(d=6, h=port_height);
                }
            }
        }
        mainboard_offset() {
            translate([0, 0, mainboard_height]) {
                rpi_cutouts();
                mainboard(r=3.5, height=3);
            }
            mainboard_mounting() {
                cylinder(d=2.8, h=mainboard_height+1);
                hull() {
                    translate([0, 0, 0.8]) cylinder(d1=5.1, d2=2.5, h=1.3);
                    translate([0, 0, -0.5]) cylinder(d=5.1, h=0.1);
                }
            }
        }
        cx_offset() {
            translate([0, 0, cx_height]) cxadc_cutouts();
            cxadc_mounting() translate([0, 0, cx_height-5]) cylinder(d=m3_insert_d, h=6);
        }
        port_offset() {
            translate([0, 0, port_height]) port_cutouts();
            port_mounting() translate([0, 0, port_height-5]) cylinder(d=m3_insert_d, h=6);
        }
    }
}


module spacer() {
    box_bottom([case_x, case_y], 7, [3, 2], bottom_height, thickness=1.4, wall=2);
}


module hollow_extrude(height, t=1, scale=1.0) {
    linear_extrude(height=height, scale=scale)  difference() {
        children();
        offset(-t) children();
    }
}

module top() {
    vent_od = 68;
    vent_id = 48;
    vent_ud = 43.9;
    vent_h = 9;
    if (1) difference() {
        union() {
            box_top([case_x, case_y], 7, [3, 2], top_height, thickness=1.4, wall=2)
                case_insets();
        }
        mainboard_offset() translate([0, 0, mainboard_height]) rpi_cutouts();
        cx_offset() translate([0, 0, cx_height]) cxadc_cutouts();
        port_offset() translate([0, 0, port_height]) port_cutouts();
        translate([case_y/2, case_y/2, 0]) cylinder(d=vent_od, h=30);
    }


    translate([case_y/2, case_y/2, top_height]) vent(od=vent_od, id=vent_id, ud=vent_ud, h=vent_h);
    difference() {
        //color("red")
        union() {
            //translate([0, 0, top_height-0.1]) mirror([0, 0, 1]) hollow_extrude(height=vent_h-0.2, t=0.75) translate([47, 45]) square(32, center=true);
            //translate([47.65, 45.5]) translate([0, 0, top_height-0.1]) mirror([0, 0, 1]) hollow_extrude(height=12.5, t=0.75) circle(d=25);
            a = 30.7;
            b = 26.0;
            translate([47.65, 45.5]) {
                translate([0, 0, top_height-0.1]) mirror([0, 0, 1]) hollow_extrude(height=vent_h-1.1, t=0.5) circle(d=a);
                translate([0, 0, top_height-(vent_h-1)]) mirror([0, 0, 1]) hollow_extrude(height=12-(vent_h-1), t=0.5, scale=(b/a)) circle(d=a);
                translate([0, 0, top_height-11.999]) mirror([0, 0, 1]) hollow_extrude(height=0.501, t=0.5*(b/a)) circle(d=b);
            }
        }
        translate([case_y/2, case_y/2, top_height]) mirror([0, 0, -1]) {
            hollow_cylinder(od=vent_od, id=vent_ud+0.1, h=vent_h);
            rotate(7.2) mirrorkeep([1, -1]) rotate(6.9) translate([-0.5-vent_ud/2, 0, 0]) cube([2, 1, vent_h-1]);
        }
    }
}


//rotate([180, 0, 0]) translate([0, -250]) 
//translate([0, 0, 50])
top();
bottom();
if (1) {
mainboard_offset() {
    translate([0, 0, mainboard_height]) {
        color("grey") mainboard();
        color("lightgrey") rpi();
    }
}

cx_offset() {
    translate([0, 0, cx_height]) {
        cxadc_board();
        //cxadc_cutouts();
    }
}
port_offset() {
    translate([0, 0, port_height]) port_board();
}
}

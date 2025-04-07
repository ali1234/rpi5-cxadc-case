// box

$fa = 0.1;
$fs = 0.1;


module mirrorkeep(x) {
    children();
    mirror(x) children();
}


module offset_diff(d) {
    difference() {
        offset(d[0]) children();
        offset(d[1]) children();
    }
}


module fill() {
    for (i = [-10:10]) {
        translate([0, i*30]) square([500, 1.2], center=true);
    }
}


module shell(height, thickness, wall, top, gap=2, brace=true) {
    wall_height = height + (top ? -2-(gap/2) : -(gap/2));
    lip_height = height + (top ? -(gap/2) : 2+(gap/2));

    linear_extrude(height=thickness, convexity=2) children();
    linear_extrude(height=wall_height, convexity=2) offset_diff([0, -wall]) children();
    linear_extrude(height=lip_height, convexity=2)
        offset_diff(top ? [0, 0.1-wall/2] : [-wall/2, -wall]) children();
    
    if (brace) linear_extrude(height=3, convexity=4) intersection() {
        union() {
            rotate(45) fill();
            rotate(-45) fill();
        }
        children();
    }
}


module outline(size, radius) {
    offset(radius) offset(-radius) difference() {
        square(size, center=true);
        children();
    }
}




module screw_pos(size, offset, screws) {
    p = [for (i = size) (i - (offset*2))];
    n = screws[0] - 1;
    for (i = [0:n]) {
        x = n == 0 ? 0 : (i/n) - 0.5;
        mirrorkeep([0, 1]) translate([x*p[0], 0.5*p[1]]) rotate(90) children();
    }
    m = screws[1] - 1;
    for (i = [0:m]) {
        x = m == 0 ? 0 : (i/m) - 0.5;
        mirrorkeep([1, 0]) translate([0.5*p[0], x*p[1]]) children();
    }
}


module box_bottom(size, radius, screws, height, thickness=1, wall=2, gap=1.5, brace=true, center=false) {
    translate([center?0:size[0]/2, center?0:size[1]/2, -height]) difference() {
        union() {
            shell(height, thickness, wall, false, gap=gap, brace=brace) outline(size, radius) children();
            linear_extrude(height=height+2+(gap/2), convexity=5) intersection() {
                offset(-(wall/2)-0.1) outline(size, radius) children();
                union() {
                    screw_pos(size, radius, screws) hull() {
                        circle(r=radius-wall);
                        translate([radius*2, 0]) circle(r=radius-wall+0.5);
                    }
                }
            }
        }
        translate([0, 0, -0.1]) screw_pos(size, radius, screws) {
            hull() {
                cylinder(d=6.2, h=height-3.2);
                translate([0, 0, height-3.1]) cylinder(d1=6.2, d2=3.4, h=1.4);
            }
            cylinder(d=3.4, h=height+3+(gap/2));
        }
    }
}


module box_top(size, radius, screws, height, thickness=1, wall=2, gap=1.5, brace=true, center=false) {
    mirror([0, 0, 1]) translate([center?0:size[0]/2, center?0:size[1]/2, -height]) difference() {
        union() {
            shell(height, thickness, wall, true, gap=gap, brace=brace) outline(size, radius) children();
            linear_extrude(height=height-2-(gap/2), convexity=5) intersection() {
                offset(-wall/2) outline(size, radius) children();
                union() {
                    screw_pos(size, radius, screws) hull() {
                        circle(r=radius-wall);
                        translate([radius*2, 0]) circle(r=radius-wall+0.5);
                    }
                }
            }            
        }
        translate([0, 0, height-7-(gap/2)]) screw_pos(size, radius, screws) {
            cylinder(d=4, h=10);
            translate([0, 0, -2]) cylinder(d=2.5, h=10);
        }
    }
}


module awesome_box(size, radius, screws, height, thickness=1, wall=2) {
    translate([0, -10]) rotate([180, 0]) 
    box_top(size, radius, screws, height, thickness, wall) children();
    translate([0, 10]) 
    box_bottom(size, radius, screws, height, thickness, wall) children();
    
}


awesome_box([200, 100], 7, [4, 3], 20, 0.8, 2) translate([0, 50]) square(20, center=true);


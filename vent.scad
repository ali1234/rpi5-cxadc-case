$fa = 0.5;
$fs = 0.5;

module hollow_cylinder(od, id, h, center=false) {
    difference() {
        cylinder(d=od, h=h, center=center);
        translate([0, 0, -1]) cylinder(d=id, h=h+2, center=center);
    }
}

module rotate_array(n) {
    for (x = [0:n]) {
        rotate(360*x/n) children();
    }
}

module vent(od=70, id=64, ud=54, h=10, t=1) {
    mirror([0, 0, 1]) {
        hollow_cylinder(od=od+t*2, id=od, h=h);
        cylinder(d=id, h=t);
        rotate_array(100) translate([(od + ud)/4, 0, h/2]) cube([(od-ud)/2, 0.5, h], center=true);
        translate([0, 0, h-1]) hollow_cylinder(od=od+2, id=ud, h=t);
    }
}

vent();

echo(version=version());

speaker_width=167;

module square_pipe_grid_face(num_holes=16, spacing=9, edge_length=20, rounding_radius=6) {
    for (i = [0:(sqrt(num_holes) - 1)]) {
        for (j = [0:(sqrt(num_holes) - 1)]) {
            translate([rounding_radius * 2 + 1 + i*(edge_length+spacing), rounding_radius * 2 + 1 + j*(edge_length+spacing)]) {         
                difference() {
                    minkowski() {
                        square(edge_length);
                        circle(rounding_radius);
                    }
                    
                    minkowski() {
                        square(edge_length - 1);
                        circle(rounding_radius - 2);
                    }
                }
            }
        }
    }
}

module support2Dface(num=4) {
    difference() {
        square(20,20);
        translate([10,-5,0])
            circle(15);
        translate([10,30,0])
            circle(15);
    }
}

//translate([500,500,500])
    //linear_extrude(500)
        //support2Dface();

module pipe_bend() {
    rotate_extrude()            
        square_pipe_grid_face();    
}

module pipe_bend_180() {
    difference() {
        pipe_bend()
        translate([-125, 0])
            cube(250,250);
    }
}

module pipe_bend_180() {
    difference() {
        pipe_bend();
        translate([-125, 0])
            cube(1000,1000);
    }
}


module pipe_bend_90() {
    difference() {
        pipe_bend_180();
        translate([0, -125])
            cube(1000,1000);
    }
}

corner_thickness = 4*20 + 3*9;
straight_segment_length = 4*20 + 3*9;
top_layer_base_height = corner_thickness + straight_segment_length + 30;

module bend1() {
    translate([0, 0, top_layer_base_height])
       mirror([1,0,1])
           pipe_bend_90();
}

/*module support_bend1() {
    translate([0, 0, top_base_layer_height])
        for (i = [0:4]) {
            deg_span = 360 / 4;
            deg_rotated = deg_span * i;
            rotate([0,0,deg_rotated])
                difference(
                    rotate_extrude(deg_span)
                        rectangle([
                }            
        }
}*/
/*translate([500,500,500])
rotate_extrude(360) {
    //rotate([0,90,0]);
    translate([250,250,250])
    circle(500);
} */
        
//translate([100,100,100])
    //support_bend1();

module straight_segment() {
    linear_extrude(straight_segment_length + 30)
        square_pipe_grid_face();
}

module straight1() {
    translate([-straight_segment_length - 26, -straight_segment_length - 26, corner_thickness])
        straight_segment();
}

module bend2() {
    translate([-straight_segment_length - 26, 0, corner_thickness])
        rotate([90, 0, 90])
            pipe_bend_180();
}

module bend3() {
    translate([0,straight_segment_length + 26,corner_thickness])
        rotate([-90,0,180])
            pipe_bend_180();
}

module bend4() {
    translate([straight_segment_length + 26, 0, 0])
        bend2();
}

module straight5() {
    translate([straight_segment_length + 26, 0, 0])
        straight1();
}

module bend6() {
    translate([straight_segment_length + 26, 0, 0])
        bend1();
}

module straight7() {
    translate([0,-120,top_layer_base_height])
        rotate([-90,0,0])
            straight1();
}

module speakerflange() {
    translate([0,373,top_layer_base_height])
    rotate([90,0,0])
    translate([0,0,top_layer_base_height + 8]) {
        union() {
            linear_extrude(127) {
                difference() {
                    square_pipe_grid_face();
                    translate([15,10,0])
                        square(105);
                }
            }
            linear_extrude(15) {
                difference() {
                    union() {
                        square_pipe_grid_face();
                        translate([12,11,0])
                            minkowski() {
                                square(110);
                                circle(3);
                            }
                    }
                    translate([65,65,65])
                    circle(50);
                }
            }
        }
    }
}

module flangesupports() {
    for (i = [1:3]) {
        height = top_layer_base_height + 127/4*i;
        translate([0,0,height])
        linear_extrude(3) {
            difference() {
                translate([0,0])
                    square(125);
                translate([63,100])
                    circle(70);
            }
        }
    }
}

module support_face() {
    difference() {
        square(18,25);
        translate([-11,10,0])
            circle(14);
        translate([29,10,0])
            circle(14);
    }    
}

module straight_supports() {
    for (i = [0:3]) {
        translate([30 * i, 0, 0])
        linear_extrude(straight_segment_length + 25) {
            support_face();
        }
    }
}

module support90() {
    rotate_extrude(angle = 90) {
        for (i = [0:3]) {
            translate([35 * i, 0]) {
                support_face();
            }
        }
    }
}

module support1() {
    translate([-11,straight_segment_length + 14,top_layer_base_height + 123])
    rotate([90,90,0])
    straight_supports();
}

module support2() {
    translate([-10,0,top_layer_base_height])
    rotate([0,-90,180])
    support90();
}

module support3() {
    translate([0,127*2 - 9,127])
    rotate([90,0,0])
    union() {
        support1();
        // FIXME extend this one a bit since something is off about the ends of our corners.
        translate([0,-13,0])
        support1();
    }
}

module support4() {
    translate([0,0,350])
    mirror([0,0,1])
    support2();
}

module support5() {
    mirror([0,1,0])
    support4();
}

module support6() {
    difference() {
        difference() {
            translate([0,137,0]) {
                support3();
                // FIXME hack to get top of last little infill section chopped off
            }
            translate([-50, 0, 200])
                cube(150);
        }
        bend3();
    }
}

scale(1.56)
union() {
    bend1();
    straight1();
    bend2();
    bend3();
    bend4();
    straight5();
    bend6();
    straight7();
    speakerflange();
    flangesupports();
    support1();
    support2();
    support3();
    support4();
    support5();
    support6();
}

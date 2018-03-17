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
}

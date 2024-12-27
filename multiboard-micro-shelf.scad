/* Multiboard Micro Shelf */

/* [Advanced] */

$fn = 200;
preview_sample_multiboard = true;
animate = false;


/* [Hidden] */

nothing=0.01; // z-fighting fix
multiboard_grid_offset = 25;
multiboard_peghole_width = 14.64;
click_height = 36.8;
click_mount_depth = 4;
multipoint_rail_max_width = 18.6;
multipoint_rail_max_depth = 2.2;
multipoint_rail_offset = -6; // Adjust the holder position to match the rail slot
shelf_offset = 1.9; // Adjust shelf positioning on mount


/* [Shelf] */

shelf_width = 15.8;
shelf_depth = 8.1;
shelf_height = 4.6;
wall_thickness = 1.8;
nose = 80; // [0 : 100]


/* [Holder] */

mount_type = "click"; // [click:Pegboard Click, rail:Multipoint Rail Slot]

click_position = 17; // [-17 : 17]


/* Calculations */

animated_click_position = 17 * sin($t*360); // Animation
calculated_click_position = $preview && animate ? animated_click_position : click_position;

nose_offset = nose * wall_thickness / 2 / 100;

// Rail

rail_width = multipoint_rail_max_width + click_mount_depth;
rail_depth = click_mount_depth;
rail_height = click_height;

// Sample Multiboard

sample_multiboard_size = 4 * multiboard_grid_offset;
sample_multiboard_offset = sample_multiboard_size / 2 + multiboard_grid_offset / 2;


module sampleMultiboardCorner() {
  translate([-sample_multiboard_offset, -sample_multiboard_offset, 2]) {
    color("#cccccc") import("4x4 Multiboard Corner.stl", $fn=200);
  }
}

module pegboardClick() {
  rotate([0, -90, 90]) {
    translate([-6.6, 0, -0.5]) {
      import("Pegboard Click.stl", $fn=200);
    }
  }
}

module railSlot() {
  rotate([0, 180, 0]) {
    translate([0, 0, click_mount_depth]) {
      difference() {
        union() {
          cube([rail_height, rail_width, rail_depth], center=true);
          translate([0, 0, -rail_depth + multipoint_rail_max_depth / 2]) {
            cube([rail_height, rail_width, rail_depth / 2], center=true);
          }
        }
        rotate([180, 0, 90]) {
          translate([0, multiboard_grid_offset / 2 - click_mount_depth, -multipoint_rail_max_depth]) {
            import("Lite Multipoint Rail - Negative.stl", $fn=200);
          }
        }
      }
    }
  }
}

module holder() {
  translate([-shelf_height + shelf_offset, -shelf_width / 2, 0]) {
    cube([wall_thickness, shelf_width, shelf_depth + click_mount_depth]);
    translate([-shelf_height, 0, shelf_depth + click_mount_depth]) {
      cube([shelf_height + wall_thickness, shelf_width, wall_thickness]);
      if (nose_offset > 0) {
        translate([wall_thickness / 2, 0, wall_thickness / 2 - nose_offset]) {
          rotate([-90, 0, 0]) {
            cylinder(shelf_width, d=wall_thickness);
          }
        }
      }
    }
  }
}


/* Main */

if ($preview && preview_sample_multiboard) {
  translate([
    shelf_height / 2 + calculated_click_position - click_height / 2 + multiboard_peghole_width / 2 + (mount_type == "click" ? 0 : multipoint_rail_offset),
    0,
    0
  ]) {
    sampleMultiboardCorner();
  }
}

rotate([0, 180, 0]) {
  holder();

  translate([-shelf_height / 2 - calculated_click_position, 0, click_mount_depth]) {
    if (mount_type == "click") {
      pegboardClick();
    } else {
      railSlot();
    }
  }
}

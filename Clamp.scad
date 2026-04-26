include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = 0;
$fs = 0.25;
$fa = 1;

// Specify which part to generate
part = "all"; // "clamp", "rotator", "all"
//part = "rotator"; // "clamp", "rotator", "all"
//part = "clamp"; // "clamp", "rotator", "all"

// Clamp sizing
wall_thickness = 5.0;
opening_depth = 24.0;
opening_height = 41.5; // Calipers measured 41.25 mm
clamp_width = 60.0; 
extra_width_top = 24;

// Screw hole parameters
screw_radius = 5.0;
screw_thread_pitch = 1.5;

// Revolute joint settings
joint_height = 20.0;
center_radius_small = 10.0;
center_radius_large = 15.0;
horizontal_spacing = 0.1;
vertical_spacing = 0.2;

clamp_depth = opening_depth + wall_thickness;
clamp_height = opening_height + 2 * wall_thickness;

if (part == "clamp")
{
    clamp();
}
else if (part == "rotator")
{
    rotator();
}
else if (part == "all")
{
    rotator();
    clamp();
}

module rotator()
{
    difference()
    {
        union()
        {
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height + vertical_spacing
                      ]
                     )
            {
                cylinder(r=center_radius_large + wall_thickness
                        ,h=joint_height + wall_thickness
                        ,center=false
                        );
            }
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height + joint_height + vertical_spacing
                      ]
                     )
            {
                connector_female(wall_thickness);
            }
        }
        union()
        {
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height
                      ]
                     )
            {
                cylinder(r=center_radius_small+horizontal_spacing
                        ,h=joint_height/2
                        ,center=false
                        );
            }
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height + joint_height/2-vertical_spacing
                      ]
                     )
            {
                cylinder(r=center_radius_large+horizontal_spacing
                        ,h=joint_height/2+2*vertical_spacing
                        ,center=false
                        );
            }
        }
    }
}

module clamp()
{
    difference()
    {
        union()
        {
            cube([clamp_width, clamp_depth, clamp_height]);
            translate([0, -extra_width_top, wall_thickness+opening_height])
            {
                cube([clamp_width, extra_width_top, wall_thickness]);
            }
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height
                      ]
                     )
            {
                cylinder(r=center_radius_small
                        ,h=joint_height/2
                        ,center=false
                        );
            }
            translate([clamp_width / 2
                      ,(clamp_depth - extra_width_top) / 2
                      ,clamp_height + joint_height/2
                      ]
                     )
            {
                cylinder(r=center_radius_large
                        ,h=joint_height/2
                        ,center=false
                        );
            }
        }
        union()
        {
            translate([0, 0, wall_thickness])
            {
                cube([clamp_width, opening_depth, opening_height]);
            }
        }
        translate([clamp_width/4, opening_depth/2, 0])
        {
            threaded_rod(d=2*screw_radius
                        ,l=wall_thickness
                        ,pitch=screw_thread_pitch
                        ,internal=true
                        ,bevel=true
                        ,blunt_start=false
                        ,anchor=BOTTOM
                        ,$slop=0.15
                        );
        }
        translate([3*clamp_width/4, opening_depth/2, 0])
        {
            threaded_rod(d=2*screw_radius
                        ,l=wall_thickness
                        ,pitch=screw_thread_pitch
                        ,internal=true
                        ,bevel=true
                        ,blunt_start=false
                        ,anchor=BOTTOM
                        ,$slop=0.15
                        );
        }
    }
}

module connector_female(base_thickness)
{
    connector_female_spacing = 3.15;
    connector_female_thickness = 3.10;
    connector_outer_diameter = 15.0;
    connector_inner_diameter = 5.3;
    connector_width = connector_outer_diameter;
    connector_depth = connector_female_spacing * 2 
                    + connector_female_thickness * 3;
    connector_height = 18.0;
    hex_head_width = 7.9;
    hex_head_depth = 3.5;
    hex_head_hole_tolerance = 0.4;
    hex_head_hole_radius = hex_head_width / sqrt(3) + hex_head_hole_tolerance;
    hex_captive_outer_bottom_radius = hex_head_hole_radius + hex_head_depth + 0.5;
    hex_captive_outer_top_radius = hex_head_hole_radius + 0.5;
    hex_captive_extrusion_height = connector_outer_diameter / 2
                                 - hex_captive_outer_top_radius;

    translate([-connector_width/2
              ,-connector_depth/2
              ,0
              ]
             )
    {
        difference()
        {
            union()
            {
                cube([connector_width
                     ,connector_female_thickness
                     ,  connector_height 
                      - connector_outer_diameter / 2
                      + base_thickness
                     ]
                    );
                translate([connector_outer_diameter/2
                          ,0
                          ,  connector_height 
                           - connector_outer_diameter / 2
                           + base_thickness
                          ]
                         )
                {
                    rotate([-90,0,0])
                    {
                        cylinder(h=connector_female_thickness
                                ,r=connector_outer_diameter/2
                                ,center=false
                                );
                    }
                }
                
                translate([0, connector_female_thickness + connector_female_spacing, 0])
                {
                    cube([connector_width
                         ,connector_female_thickness
                         ,  connector_height 
                          - connector_outer_diameter / 2
                          + base_thickness
                         ]
                        );
                    translate([connector_outer_diameter/2
                              ,0
                              ,  connector_height 
                               - connector_outer_diameter / 2
                               + base_thickness
                              ]
                             )
                    {
                        rotate([-90,0,0])
                        {
                            cylinder(h=connector_female_thickness
                                    ,r=connector_outer_diameter/2
                                    ,center=false
                                    );
                        }
                    }
                }
                
                translate([0, 2 * (connector_female_thickness + connector_female_spacing), 0])
                {
                    cube([connector_width
                         ,connector_female_thickness
                         ,  connector_height 
                          - connector_outer_diameter / 2
                          + base_thickness
                         ]
                        );
                    translate([connector_outer_diameter/2
                              ,0
                              ,  connector_height 
                               - connector_outer_diameter / 2
                               + base_thickness
                              ]
                             )
                    {
                        rotate([-90,0,0])
                        {
                            cylinder(h=connector_female_thickness
                                    ,r=connector_outer_diameter/2
                                    ,center=false
                                    );
                        }
                    }
                }
                
                // Tapered captive hex head counterbore
                translate([connector_outer_diameter / 2
                          ,0
                          ,  connector_height
                           - connector_outer_diameter / 2
                           + base_thickness
                          ]
                         )
                {
                    rotate([90, 0, 0])
                    {
                        cylinder(h=hex_captive_extrusion_height
                                ,r1=connector_outer_diameter/2
                                ,r2=hex_captive_outer_top_radius
                                ,center=false
                                );
                    }
                }    
            }
            
            // Remove screw hole
            translate([connector_width / 2
                      ,0
                      , base_thickness
                      + connector_height
                      - connector_outer_diameter / 2
                      ]
                     )
            {
                rotate([-90,0,0])
                {
                    cylinder(h=connector_depth
                            ,r=connector_inner_diameter/2
                            ,center=false
                            );
                }
            }
            
            // Remove hex head counterbore
            translate([connector_width / 2,
                      ,  hex_head_depth 
                       - hex_captive_extrusion_height
                      ,  connector_height
                       - connector_outer_diameter / 2
                       + base_thickness
                      ]
                     )
            {
                difference()
                {
                    rotate([90, 0, 0])
                    {
                        cylinder(h=hex_head_depth
                                ,r=hex_head_hole_radius
                                ,center=false
                                ,$fn=6
                                );
                    }
                }
            }
        }
    }
}

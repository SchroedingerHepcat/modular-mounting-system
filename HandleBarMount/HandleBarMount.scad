$fn = 0;
$fs = 0.25;
$fa = 1;

handlebar_diameter = 22.5;
padding_thickness = 1.1;
hex_head_width = 7.9;
hex_head_depth = 3.5;
hex_head_hole_tolerance = 0.4;
screw_diameter = 3.0;
screw_head_diameter = 5.4;
screw_head_depth = 3.0;
screw_length = 13.1;
nut_depth = 2.3;
nut_width = 5.4; // face-to-face
nut_hole_tolerance = 0.1;
brace_thickness = 1.6;
width = 40.0;


connector_female_spacing = 3.15;
connector_female_thickness = 3.10;
connector_outer_diameter = 15.0;
connector_inner_diameter = 5.3;
connector_width = connector_outer_diameter;
connector_depth = connector_female_spacing * 2 
                + connector_female_thickness * 3;
connector_height = 18.0;

inner_diameter = handlebar_diameter + 2 * padding_thickness;
outer_diameter = inner_diameter + brace_thickness;

connector_base_thickness = outer_diameter / 2
                         - sqrt( pow(outer_diameter/2, 2)
                               - pow(connector_outer_diameter/2, 2)
                               );
                               

screw_base_width = screw_head_diameter + 2;
screw_base_length = screw_length + 1;
screw_base_chord_depth = outer_diameter / 2
                       - sqrt( pow(outer_diameter / 2, 2)
                             - pow(screw_base_length / 2, 2)
                             );
opening_thickness = screw_length
                  - screw_head_depth
                  - nut_depth - 1
                  - 2 * brace_thickness;
                  
nut_hole_depth = nut_depth + 0.7;
nut_hole_radius = nut_width / sqrt(3) + nut_hole_tolerance;

hex_head_hole_radius = hex_head_width / sqrt(3) + hex_head_hole_tolerance;
hex_captive_outer_bottom_radius = hex_head_hole_radius + hex_head_depth + 0.5;
hex_captive_outer_top_radius = hex_head_hole_radius + 0.5;
hex_captive_extrusion_height = connector_outer_diameter / 2
                             - hex_captive_outer_top_radius;

difference()
{
    
    union()
    {
        translate([-connector_width / 2
                  ,  outer_diameter / 2
                   - connector_base_thickness
                  , connector_depth / 2
                  ]
                 )
        {
            rotate([-90, 0, 0])
            {
                connector_female(connector_base_thickness);
            }
        }
        cylinder(h=width, r=outer_diameter/2, center=true);
        
        // Screw plates
        translate([outer_diameter / 2 - screw_base_chord_depth
          ,-screw_base_length / 2
          ,-width / 2
          ]
         )
        {
            cube([  screw_base_width
                  + screw_base_chord_depth
                 ,screw_base_length
                 ,width
                 ]
                );
        }
    }
    
    // Remove central hole for handlebars
    cylinder(h=width, r=inner_diameter/2, center=true);
    
    // Remove split for assembly and tensioning
    translate([0, -opening_thickness/2, -width/2])
    {
        cube([outer_diameter + screw_base_width
             ,opening_thickness
             ,width
             ]
            );
    }
    
    // Remove screw holes
    translate([outer_diameter/2 + screw_base_width/2, 0, width/4])
    {
        rotate([90, 0, 0])
        {
            cylinder(h=screw_base_length, r=screw_diameter/2, center=true);
        }
    }
    translate([outer_diameter/2 + screw_base_width/2, 0, -width/4])
    {
        rotate([90, 0, 0])
        {
            cylinder(h=screw_base_length, r=screw_diameter/2, center=true);
        }
    }
    
    // Counterbores for screw heads
    translate([outer_diameter/2 + screw_base_width/2
          ,screw_base_length/2 - screw_head_depth/2
          ,width/4
          ]
          )
    {
        rotate([90, 0, 0])
        {
            cylinder(h=screw_head_depth
                    ,r=(screw_head_diameter + 1) / 2
                    ,center=true
                    );
        }
    }
    translate([outer_diameter/2 + screw_base_width/2
              ,screw_base_length/2 - screw_head_depth/2
              ,-width/4
              ]
              )
    {
        rotate([90, 0, 0])
        {
            cylinder(h=screw_head_depth
                    ,r=(screw_head_diameter + 1) / 2
                    ,center=true
                    );
        }
    }
    
    // Nut holes
    translate([outer_diameter/2 + screw_base_width/2
              ,-(screw_base_length/2 - nut_hole_depth/2)
              ,width/4
              ]
             )
    {
        rotate([90, 30, 0])
        {
            cylinder(h=nut_hole_depth
                    ,r=nut_hole_radius
                    ,center=true
                    ,$fn=6
                    );
        }
    }
    translate([outer_diameter/2 + screw_base_width/2
              ,-(screw_base_length/2 - nut_hole_depth/2)
              ,-width/4
              ]
              )
    {
        rotate([90, 30, 0])
        {
            cylinder(h=nut_hole_depth
                    ,r=nut_hole_radius
                    ,center=true
                    ,$fn=6
                    );
        }
    }
    
    // Round over corners
    translate([outer_diameter / 2
              ,screw_base_length / 2
              ,width / 2 - screw_base_width
              ]
             )
    {
        rotate([90, 0, 0])
        {
            fillet(radius=screw_base_width, height=screw_base_length);
        }
    }
    mirror([0, 0, 1])
    {
        translate([outer_diameter / 2
                  ,screw_base_length / 2
                  ,width / 2 - screw_base_width
                  ]
                 )
        {
            rotate([90, 0, 0])
            {
                fillet(radius=screw_base_width, height=screw_base_length);
            }
        }
    }
}

module fillet(radius, height)
{
    difference()
    {
        cube([radius+0.01, radius+0.01, height]);
        cylinder(h=height, r=radius, center=false);
    }
}

module connector_female(base_thickness)
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
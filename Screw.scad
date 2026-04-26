include <BOSL2/std.scad>
include <BOSL2/threading.scad>

screw_head_depth = 5.0;
screw_head_radius = 10.0;
screw_radius = 5.0;
screw_length = 10.0;
screw_thread_pitch = 1.5;

module thumb_screw(head_length, head_radius, thread_length, thread_radius)
{
    // Knurled thumb grip
    knurling_texture = [[0, 1], [1, 0]];
    head_diameter = 2 * head_radius;
    cyl(h=head_length
       ,d=head_diameter
       ,texture=knurling_texture
       ,tex_size=[3, 1]
       ,tex_depth=1.0
       ,tex_inset=true
       ,anchor=BOTTOM
       );

    // Threaded screw
    thread_diameter = 2 * thread_radius;

    translate([0, 0, head_length])
    {
        threaded_rod(d=thread_diameter
                    ,l=thread_length
                    ,pitch=1.5
                    ,bevel=true
                    ,blunt_start=false
                    ,anchor=BOTTOM
                    );
    }
}

thumb_screw(screw_head_depth, screw_head_radius, screw_length, screw_radius);

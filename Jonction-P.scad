include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 0 : 100; 

//in milimeters
Section = 27; // [10:35]

//in milimeters
Lenght_of_arms = 27; // [10:35]

//in milimeters
Thickness = 2; // [2:5]

Number_of_screws = 2; // [0:3]

Screw_size="M3"; // ["M2", "M3", "M4", "M5", "M6"]

Generate_rib_hole = true;

Generate_top_chamfer = true;

Generate_bottom_chamfer = true;

//constant
angle = atan(2/sqrt(2));

module cubeBase()
{
    zrot_copies(n=3)
    right(Section*1/3)
    yrot(90-angle)
    diff()
    cube([Lenght_of_arms,Section+2*Thickness,Section+2*Thickness], anchor=LEFT+BOTTOM)
    tag("remove")
    {
        if(Number_of_screws>0)
        {
            attach(BOTTOM)
            xcopies(Lenght_of_arms/Number_of_screws, Number_of_screws)
            screw_hole(str(Screw_size,",",Thickness*2),head="flat",counterbore=0, anchor=TOP);
        }
        cube([Lenght_of_arms,Section,Section], anchor=CENTER);
    }
}


module wallUp()
{
    zrot_copies(n=3)
    hull()
    {
        recolor("red")
        right(Section*1/3)
        yrot(90-angle)
        back(Section/2+Thickness/2)
        cube([Thickness, Thickness, Section+2*Thickness], anchor=BOTTOM+LEFT);
        
        recolor("blue")
        zrot(120)
        right(Section*1/3)
        yrot(90-angle)
        fwd(Section/2+Thickness/2)
        cube([Thickness, Thickness, Section+2*Thickness], anchor=BOTTOM+LEFT);
    }
}



module wallDown()
{
    zrot_copies(n=3)
    
    diff()
    {
        hull()
        {
            recolor("red")
            right(Section*1/3)
            yrot(90-angle)
            back(Section/2+Thickness/2)
            cube([Lenght_of_arms, Thickness, Thickness], anchor=BOTTOM+LEFT);
            
            recolor("blue")
            zrot(120)
            right(Section*1/3)
            yrot(90-angle)
            fwd(Section/2+Thickness/2)
            cube([Lenght_of_arms, Thickness, Thickness], anchor=BOTTOM+LEFT);
        }
        tag("remove")
        {
            if(Generate_rib_hole)
            {
                recolor("purple")
                zrot(60)
                right(Section*2/3-sqrt(Thickness)*2)
                yrot(angle)
                right((Lenght_of_arms*cos(angle))-Thickness*cos(angle)-(sqrt(2)*Lenght_of_arms)/2*tan(angle-45))
                yrot(-180)
                screw_hole(str(Screw_size,",",50),head="none",counterbore=0, anchor=CENTER);
            }
        }
    }
}


module jonction()
{
    union()
    {
        cubeBase();
        wallUp();
        wallDown();
    }
}

module planar()
{

    top_half(z=Generate_bottom_chamfer?-(Lenght_of_arms*cos(angle))+(sqrt(2)*Thickness-Thickness*cos(angle)):-100)

    bottom_half(z=Generate_top_chamfer?(Section+2*Thickness)*sin(angle)-Thickness*cos(angle):100)

    jonction();
}

planar();

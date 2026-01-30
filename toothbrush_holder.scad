use <lib/hex.scad>

module basePlate(
    cupRadius=30,
    cupBuffer=0.5,
    wallThickness=1.5,
    centreSpacing=50,
    Base_Height=10,
    Cup_Recess=8,
) {

    difference() {
        linear_extrude(Base_Height) 
        union() {
            translate([-centreSpacing,0])
            circle(cupRadius + cupBuffer + wallThickness);

            translate([centreSpacing,0])
            circle(cupRadius+cupBuffer + wallThickness);
            
            square([centreSpacing * 2
                    ,2*(cupRadius + cupBuffer + wallThickness)], center=true);
        }
        
        translate([-centreSpacing,0,Base_Height - Cup_Recess])
        linear_extrude(Base_Height)
        circle(cupRadius + cupBuffer);
        
        translate([centreSpacing,0,Base_Height - Cup_Recess])
        linear_extrude(Base_Height)
        circle(cupRadius + cupBuffer);
    }
}

module cup(
    cupRadius = 30,
    cupHeight = 110,
    wallThickness = 1.5,
    baseThickness = 2,
) {
    linear_extrude(baseThickness) 
    intersection() {
        circle(cupRadius - (wallThickness / 2));
        translate([-cupRadius, -cupRadius])
        hexMesh2d(cellSize = cupRadius / 6, meshWidth = 0.8);
    }   
    difference() {
        linear_extrude(cupHeight, twist=360) circle(cupRadius, $fn=25);
        cylinder(h = cupHeight + 1, r1 = cupRadius - wallThickness, , r2 = cupRadius - wallThickness);
    }
}

module pickHolder(
    height = 40,
    radius = 8,
    wallThickness = 1,
) {
    innerRad = radius - wallThickness;
    difference() {
        linear_extrude(height, twist=260)
            circle(radius, $fn=20);
        cylinder(h = height + 1, r1 = innerRad, r2 = innerRad, $fn=20);
    }
}

union() {
    basePlate(centreSpacing = 40);
    translate([0,17.5,0])
    pickHolder();
}

translate([-40, 100])
cup();

translate([40, 100])
cup();

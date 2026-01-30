module hexMesh2d(
    cellSize = 2,
    meshWidth = 0.1,
    size = 10
) {
    xOffset = 3/2 * cellSize;
    yOffset = sqrt(3) * cellSize;
    fillet = meshWidth / 3;
    
    module hexRing2d() {
        offset(r = fillet)
        offset(delta = -fillet)
        difference() {
            circle(cellSize, $fn = 6);
            circle(cellSize - meshWidth, $fn = 6);
        }
    }
    
    module hexLine() {
        for(i = [0 : 1: size]) {
            translate([0, yOffset * i, 0])
            hexRing2d();
        }   
    }
    
    module halfGrid() {
        for (i = [0: 2: size]) {
            translate([xOffset * i, 0, 0])
            hexLine();
        }
    }
    
    union() {
        halfGrid();
        translate([xOffset, yOffset / 2, 0]) halfGrid();
    }

}

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

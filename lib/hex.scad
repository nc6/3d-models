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

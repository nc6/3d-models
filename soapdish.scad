use <lib/hex.scad>

// --- Parameters ---
wallThickness = 1.5;
supportThickness = 2.5;
length = 120;
width = 90;
height = 20;
insetHeight = 4;
drainWidth = 35; 
lipExtension = 15; 
lipWallHeight = 3; // Height of the little curbs on the spout
min_height = 2;    
slope = 0.08;      
$fn = 64;

// --- Modules ---

module rndSquare(length, width, chamfer = 10) {
    offset(r=+chamfer) offset(r=-chamfer) square([length, width], center = true);
}

module slopedSurface(length, width, min_height = 2, slope = 0.05, chamfer = 10) {
    // The Z offset ensures the lowest point (Y = -width/2) is exactly min_height
    z_offset = min_height + (width/2 * slope);
    
    hull() {
        linear_extrude(height = 0.1) 
            rndSquare(length, width, chamfer);

        multmatrix(m = [ [1, 0, 0, 0],
                         [0, 1, 0, 0],
                         [0, slope, 1, z_offset], 
                         [0, 0, 0, 1] ])
            linear_extrude(height = 0.1) 
                rndSquare(length, width, chamfer);
    }
}

module pouringLip() {
    translate([0, -width/2, 0]) {
        // 1. The floor of the lip (sloped tongue)
        hull() {
            translate([-drainWidth/2, 0, 0])
                cube([drainWidth, 0.1, min_height]);
            translate([-drainWidth/2, -lipExtension, 0])
                cube([drainWidth, 0.1, max(0.5, min_height - (lipExtension * slope))]);
        }

        // 2. The side walls (curbs)
        // These stay outside the drainWidth area
        for(side = [-1, 1]) {
            translate([side * (drainWidth/2 + wallThickness/2), 0, 0])
            hull() {
                // Back at the wall
                translate([-wallThickness/2, 0, 0])
                    cube([wallThickness, 0.1, min_height + lipWallHeight]);
                // Front at the tip
                translate([-wallThickness/2, -lipExtension, 0])
                    cube([wallThickness, 0.1, max(0.5, min_height - (lipExtension * slope)) + lipWallHeight]);
            }
        }
    }
}

module tray() {
    module wallShape2d(l, w, t = wallThickness) {
        difference() {
            rndSquare(l, w);
            offset(r=-t) rndSquare(l, w);
        }
    }

    difference() {
        union() {
            // 1. Main Walls
            linear_extrude(height = height) 
                wallShape2d(length, width);
            
            // 2. The Sloped Bottom
            slopedSurface(length, width, min_height = min_height, slope = slope);
            
            // 3. Supporting brim
            linear_extrude(height = height - insetHeight) 
                wallShape2d(length, width, t = wallThickness + supportThickness);  
            
            // 4. The Spout/Lip
            pouringLip();
        }

        // 5. THE DRAIN CUTOUT
        // We move the cutter slightly forward and up so it doesn't delete the lip itself
        translate([0, -width/2, height/2 + min_height]) 
            cube([drainWidth, wallThickness * 2 + supportThickness * 2 + 0.01, height], center = true);
    }
}

module inset(){
    tol = 0.4;
    insetL = length - wallThickness * 2 - tol;
    insetW = width - wallThickness * 2 - tol;
    
    linear_extrude(insetHeight)
    union() {
        difference() {
            rndSquare(insetL, insetW);
            rndSquare(insetL - supportThickness * 2, insetW - supportThickness * 2);
        }
        
        intersection(){
            rndSquare(insetL, insetW);
            // Centering the hex mesh based on the object
            translate([-length/2, -width/2]) 
                hexMesh2d(size = 30, cellSize = 8, meshWidth = 0.8);
        }
    } 
}

// --- Render ---
tray();
translate([0, width + 20, 0]) inset();
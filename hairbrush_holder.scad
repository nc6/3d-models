rail_diam=23;
hb_width=22;
hb_depth=15;
collar_thickness=2;
$fn = 64;

//linear_extrude(2) {
//
//offset(r=-0.5) offset(r=0.5)
//difference() {
//  circle(d = rail_diam + collar_thickness);
//  circle(d = rail_diam);
//  polygon([[0,0],[20,20], [20,-20]]); 
//}
//
//
//
//translate([-20,0])
//difference() {
//  resize([hb_depth + collar_thickness, hb_width + collar_thickness]) circle();
//  resize([hb_depth, hb_width]) circle();
//  polygon([[0,0],[-20,20], [-20,-20]]); 
//}
//}


linear_extrude(15) {
offset(r=0.5) offset(delta=-0.5)
difference() {
  hull(){
      circle(d = rail_diam + 2*collar_thickness);
      translate([-25,0])
      resize([hb_depth + 2*collar_thickness, hb_width + 2*collar_thickness]) circle();
  }

  circle(d = rail_diam);
  polygon([[0,0],[20,20], [20,-20]]);
  
  translate([-25,0])
  resize([hb_depth, hb_width]) circle();
  polygon([[-20,0],[-40,20], [-40,-20]]); 
}
}
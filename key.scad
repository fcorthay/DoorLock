// key.scad - old style key
include <shapes.scad>
useShapesFromDrawing = true;
isTopLevel = true;
                                                                   // parameters
bowType = "logo";
//bowType = "toric";
addBitSlit = true;
                                                               // key dimensions
shaftDiameter = 8;
shaftLength = 100;

bitWidth = 8;
bitLength = 17;
bitHeight = 20;
bitStart = shaftLength - bitLength - 8;

bowText = "";
//bowText = "FM";
bowTextDepth = 1;
bowTextSize  = 5;
bowTextFont  = "Verdana";

bowTorusDiameter = 25;
bowTorusTubeLargeDiameter = shaftDiameter - 1;
bowTorusTubeThinDiameter = shaftDiameter - 3;
bowBallDiameter = 15;

logoBowDiameter = 40;
logoTubeDiameter = 5;
logoConeToShaftLenghtRatio = 1/5;
logoPlateHeight = 3;
bowLogoMinimal = [
  [-logoBowDiameter/(2*sqrt(2)), -logoBowDiameter/(2*sqrt(2))],
  [-logoBowDiameter/6          ,  0                          ],
  [-logoBowDiameter/(2*sqrt(2)),  logoBowDiameter/(2*sqrt(2))],
  [ 0                          ,  logoBowDiameter/6          ],
  [ logoBowDiameter/(2*sqrt(2)),  logoBowDiameter/(2*sqrt(2))],
  [ logoBowDiameter/6          ,  0                          ],
  [ logoBowDiameter/(2*sqrt(2)), -logoBowDiameter/(2*sqrt(2))],
  [ 0                          , -logoBowDiameter/6          ]
];
bowLogo = useShapesFromDrawing ? bowLogoFromDrawing : bowLogoMinimal;

bitShapeMinimal = [
  [ 0, 0],
  [ bitWidth/4, 0], [ bitWidth/4, -bitWidth], [ bitWidth/2, -bitWidth],
  [ bitWidth/2, -bitHeight], [-bitWidth/2, -bitHeight],
  [-bitWidth/2, -bitHeight*7/8], [ bitWidth/4, -bitHeight*7/8],
  [ bitWidth/4, -bitHeight/2], [-bitWidth/2, -bitHeight/2],
  [-bitWidth/2, -bitWidth], [-bitWidth/4, -bitWidth], [-bitWidth/4, 0]
];
bitShape = useShapesFromDrawing ? bitShapeFromDrawing : bitShapeMinimal;

bitSlitWidth = bitWidth/8;
bitSlitDepth = bitHeight/2;
bitSlitShapeMinimal = [
  [-bitSlitWidth,            0], [-bitSlitWidth, bitSlitDepth],
  [ bitSlitWidth, bitSlitDepth], [ bitSlitWidth,            0]
];
bitSlitShape = useShapesFromDrawing ?
  bitSlitShapeFromDrawing : bitSlitShapeMinimal;

//echo(str("bowLogoFromDrawing = ", bowLogoMinimal, ";"));
//echo(str("bitShapeFromDrawing = ", bitShapeMinimal, ";"));
//echo(str("bitSlitShapeFromDrawing = ", bitSlitShapeMinimal, ";"));

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
                                                                    // rendering
$fn = 200;  // facet number

key(isTopLevel);

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
                                                              // object geometry
module key(renderIt=true) {
  if (renderIt) {
                                                                          // bow
    color("blue")
      if (bowType == "toric") {
        toricBow();
      }
      else {
        logoBow();
      }
                                                                        // shaft
    color("green")
      shaft();
                                                                          // bit
    color("yellow")
      bit();
  }
}

//............................................................................\\
                                                                    // toric bow
module toricBow() {
                                                                         // ball
  sphere(d=bowBallDiameter);
                                                                      // toruses
  translate([-bowTorusDiameter/2, bowBallDiameter/2, 0])
    rotate_extrude(angle = 180, convexity = 10)
      translate([bowTorusDiameter/2, 0, 0])
        resize([bowTorusTubeThinDiameter, bowTorusTubeLargeDiameter])
          circle();
  translate([-bowTorusDiameter/2, -bowBallDiameter/2, 0])
    rotate_extrude(angle = -180, convexity = 10)
      translate([bowTorusDiameter/2, 0, 0])
        resize([bowTorusTubeThinDiameter, bowTorusTubeLargeDiameter])
          circle();
                                                     // top and bottom cylinders
  translate([0, 1.05*bowBallDiameter/2, 0])
    rotate([90, 0, 0])
      linear_extrude(height=1.1*bowBallDiameter)
        resize([bowTorusTubeThinDiameter, bowTorusTubeLargeDiameter])
          circle();
  translate([-bowTorusDiameter, 1.05*bowBallDiameter/2, 0])
    rotate([90, 0, 0])
      linear_extrude(height=1.1*bowBallDiameter)
        resize([bowTorusTubeThinDiameter, bowTorusTubeLargeDiameter])
          circle();
                                                                         // text
    translate([0, 0, bowBallDiameter/2-2*bowTextDepth])
      rotate([0, 0, 90])
        linear_extrude(height = 3*bowTextDepth)
          if (bowText == "CL") {
            translate([-bowTextSize/8, bowTextSize/8, 0])
              text(
                bowText[0],
                font=bowTextFont, size=bowTextSize,
                halign="center", valign="center"
              );
            translate([bowTextSize/8, -bowTextSize/8, 0])
              text(
                bowText[1],
                font=bowTextFont, size=bowTextSize,
                halign="center", valign="center"
              );
          }
          else {
            text(
              bowText,
              font=bowTextFont, size=bowTextSize,
              halign="center", valign="center"
            );
          }
}
//............................................................................\\
                                                                // bow with logo
module logoBow() {
  translate([-logoBowDiameter/2, 0, 0]) {
                                                                        // torus
    rotate_extrude(angle = 360, convexity = 10)
      translate([logoBowDiameter/2, 0, 0])
          circle(logoTubeDiameter/2);
                                                                   // inner logo
    rotate([0, 0, 90])
      translate([0, 0, -logoPlateHeight/2])
        linear_extrude(height = logoPlateHeight)
          polygon(bowLogo);
  }
}

//............................................................................\\
                                                                        // shaft
module shaft() {
    lengthWithoutHalfSpere = shaftLength - shaftDiameter/2;
                                                                     // cylinder
    if (bowType == "toric" || logoTubeDiameter >= shaftDiameter) {
      rotate([0, 90, 0])
        cylinder(h=lengthWithoutHalfSpere, d=shaftDiameter, center=false);
    }
    else {
      rotate([0, 90, 0]) {
        translate([0, 0, logoConeToShaftLenghtRatio*lengthWithoutHalfSpere])
          cylinder(
            d=shaftDiameter,
            h=(1-logoConeToShaftLenghtRatio)*lengthWithoutHalfSpere,
            center=false
          );
        cylinder(
          d1=logoTubeDiameter, d2=shaftDiameter,
          h=logoConeToShaftLenghtRatio*lengthWithoutHalfSpere,
          center=false);
      }
    }
                                                  // half shpere at end of shaft
    translate([lengthWithoutHalfSpere, 0, 0])
      sphere(shaftDiameter/2);
}

//............................................................................\\
                                                                          // bit
module bit() {
  eps = 1E-3;
  difference(){
    translate([bitStart, 0, 0])
      rotate([0, 90, 0])
        linear_extrude(height=bitLength)
          polygon(points=bitShape);
    if (addBitSlit)
      translate([
        bitStart + bitLength/2,
        -bitHeight - eps,
        -bitWidth
      ])
        linear_extrude(height=2*bitWidth)
          polygon(points=bitSlitShape);
  }
}

echo(version=version());

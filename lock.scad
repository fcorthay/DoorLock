// lock.scad - lock mechanism
include <key.scad>
                                                                         // lock
latchMargin = 1/4;
bitMargin = 1/2;
sliderWidth = 1;
                                                                        // plate
lockPlateLength = 130;
lockPlateWidth = 82;
lockPlateHeight = 1;

keyholeX = 70;
keyholeY = 26;
keyholeDiameter = shaftDiameter + 2*bitMargin;
                                                                        // latch
latchBoltWidth = 40;
latchBoltHeight = 10;
latchBoltGuideLength = 1;
latchPlateLength = lockPlateLength - 3;
//latchPlateWidth = 25;
latchPlateWidth = 20;
latchPlateHeight = 3;
latchPlateGuideWidth = 4;

latchVHolderSideAngle = 30;
                                                                       // screws
screwHolesDiameter = 5;
screwHolesConeHeight = 1;
screwHolesDistanceX = 12;
screwHolesDistanceY = 8;
                                                                       // spring
springDiameter = 1.5;
springStopDiameter = 5;

//----------------------------------------------------------------------------\\
                                                               // derived values
lockHeight = bitHeight + 2*bitMargin - lockPlateHeight;

latchBottom = (lockHeight - latchBoltHeight)/2;
latchTop = (lockPlateWidth + latchBoltWidth)/2;

latchHolderLength = keyholeX - bitHeight - lockPlateHeight;
latchBoltLength = 45;

springLength = 2*(lockPlateLength - keyholeX) - 4*lockPlateHeight;
sliderHeight = (latchBottom + lockPlateHeight)/2 - latchMargin;
springHeight = sliderHeight + springDiameter/2 + 3*latchMargin;

bitAngle = atan(bitWidth/2 / bitHeight);
verticalBitLatchDepth = (keyholeY + bitHeight)
  - (latchTop - latchPlateWidth);
deltaBitWidth = bitWidth/2*(1/cos(bitAngle) - 1);
minLatchSlitDepth = verticalBitLatchDepth + deltaBitWidth/tan(bitAngle);
latchSlitDepth = minLatchSlitDepth + bitMargin;

bitDiagonal = bitHeight/cos(bitAngle);
bitStartAngle = acos(1 - minLatchSlitDepth/bitDiagonal);
bitSlitDisplacement = bitDiagonal*sin(bitStartAngle);
latchSlitLength = bitWidth/2 + bitSlitDisplacement + bitMargin;

firstSlitOffset = lockPlateLength - keyholeX - bitWidth/2 + latchSlitLength;
slitsDistance = 2*bitSlitDisplacement;
slitOffsets = [firstSlitOffset, firstSlitOffset + slitsDistance];

latchLockerWidth = 2*bitHeight;

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
renderForPrint = false;
                                                   // print rendering parameters
showPrinterPlate = false;
printDistance = 2;
printerPlateLength = 250;
printerPlateWidth = 210;
printerPlateHeight = 1;
printerPlateMargin = 10;

printBottomPlate = true;
printTopPlate = true;
printLatch = true;
printLatchLocker = true;
printLatchPlateTopHolder = false;
printKey = true;
                                                      // 3D rendering parameters
showTopPlate = false;
showSideWalls = false;
showBackWall = true;
showLatchPlateTopHolder = true;

//----------------------------------------------------------------------------\\
                                                                    // rendering
if (renderForPrint) {
  if (showPrinterPlate) {
    color("LightBlue")
      translate([
        -printerPlateMargin/2, -printerPlateMargin/2, -printerPlateHeight
      ])
        cube(
          [printerPlateLength, printerPlateWidth, printerPlateHeight],
        center=false);
  }
                                                                 // bottom plate
  bottomPlate(printBottomPlate);
                                                                    // top plate
  translate([
    lockPlateLength + lockPlateWidth -lockPlateHeight + printDistance,
    -lockPlateHeight,
    0]
  )
    rotate([0, 0, 90])
      topPlate(printTopPlate);
                                                                        // latch
  translate([
    latchDisplacement - lockPlateHeight,
    lockPlateWidth +latchBoltWidth/2 + printDistance,
    latchBoltHeight/2
  ])
    rotate([0, 0, 180])
      latch(printLatch);
                                                                // position lock
  translate([
    latchBoltLength + bitHeight + printDistance,
    lockPlateWidth + latchPlateWidth + 2*printDistance,
    0
  ])
    latchLocker(printLatchLocker);
                                                           // latch plate holder
  translate([
    latchBoltLength + 2*bitHeight + 1.5*latchPlateGuideWidth + 2*printDistance,
    lockPlateWidth + latchPlateWidth + latchPlateGuideWidth + 2*printDistance,
    0
  ])
    latchPlateTopHolder(printLatchPlateTopHolder);
                                                                          // key
  translate([
    -bitStart + latchBoltLength + latchLockerWidth + 2*printDistance,
    lockPlateWidth + latchBoltWidth + bowTorusDiameter + printDistance,
    useLogoBow ? bitWidth/2 : bowBallDiameter/2
  ])
    key(printKey);
}
else {
                                                                         // lock
  lock();
                                                                          // key
  translate([keyholeX, keyholeY, -bitStart + lockPlateHeight + bitMargin])
    rotate([-keyAngle, -90, 0])
      key();
}

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
                                                                    // animation
fixedPosition = 6;
animate = true;  // FPS: 10, Steps: 400

lockEnteringAngle = 180 - bitStartAngle - bitAngle;
lockEnteredAngle  = 180 - bitStartAngle + bitAngle;
lockExitingAngle  = 180 + bitStartAngle - bitAngle;
lockExitedAngle   = 180 + bitStartAngle + bitAngle;
                                    // selection of angles for test or animation
specificKeyAngles = [
                                                            // 0 : key insertion
  0,
                                                     // 1-5 : to latch contact 1
  45, 90, lockEnteringAngle, lockEnteredAngle, 180,
                                                          // 6-8 : close latch 1
  lockExitingAngle, lockExitedAngle, 270,
                                                      // 7-13 : to latch entry 2
  360 - 45, 360, 360 + 45, 360 + 90, 360 + lockEnteringAngle,
                                                   // 14-15 : to latch contact 2
  360 + lockEnteredAngle, 360 + 180,
                                                        // 16-20 : close latch 2
  360 + lockExitingAngle, 360 + lockExitedAngle,
  360 + 270, 2*360 - 45, 2*360,
                                              // 21-25 : back to latch contact 2
  2*360 - 45, 360 + 270,
  360 + lockExitedAngle, 360 + lockExitingAngle, 360 + 180,
                                                        //  26-30 : open latch 2
  360 + lockEnteredAngle, 360 + lockEnteringAngle,
  360 + 90, 360 + 45, 360,
                                              // 31-33 : back to latch contact 1
  360 - 45, 270, lockExitedAngle,
                                                        //  34-39 : open latch 1
  lockExitingAngle, 180, lockEnteredAngle, lockEnteringAngle, 90, 45,
                                                          // 40 : key extraction
  0
];

halfDisplacement = 20;
clockwise = animate ? $t < 0.5 : fixedPosition <= halfDisplacement;

function animationAngle(t) =
  t < 1/8 ? 360*8*t :
  t < 2/8 ? 360           :
  t < 3/8 ? 360*(-1 + 8*t) :
  t < 4/8 ? 2*360           :
  t < 5/8 ? 360*( 6 - 8*t) :
  t < 6/8 ? 360           :
  t < 7/8 ? 360*( 7 - 8*t) :
            0;
position = fixedPosition;
keyAngle = animate ? animationAngle($t) : specificKeyAngles[position];

toClosing1 = 1; closing1 = 2; toClosing2 = 3; closing2=4; closed = 5;
toOpening2 = 6; opening2 = 7; toOpening1 = 8; opening1 = 9; open=10;
workRegion =
  clockwise ?
    keyAngle <= 180                     ? toClosing1 :
    keyAngle <= lockExitingAngle        ? closing1   :
    keyAngle <= 360 + lockEnteringAngle ? toClosing2 :
    keyAngle <= 360 + lockExitingAngle  ? closing2   :
                                          closed
  :
    keyAngle >= 360 + 180               ? toOpening2 :
    keyAngle >= 360 + lockEnteredAngle  ? opening2   :
    keyAngle >= lockExitedAngle         ? toOpening1 :
    keyAngle >= lockEnteredAngle        ? opening1   :
                                          open;
echo(str(
   "\n\n",
   "t = ", $t, "\n",
   "keyAngle = ", keyAngle, " (", keyAngle/360, ")\n",
   "clockwise = ", clockwise, "\n",
   "workRegion = ", workRegion, "\n",
   "\n"
 ));
                                                           // latch displacement
lockPosition1 = 0;
lockPosition2 = bitDiagonal*sin(bitStartAngle) - bitWidth/2 + bitMargin;
lockPosition3 = lockPosition2 + slitsDistance;
lockPosition4 = lockPosition1 + slitsDistance;
//echo(lockPosition1 = lockPosition1);
//echo(lockPosition2 = lockPosition2);
//echo(lockPosition3 = lockPosition3);
//echo(lockPosition4 = lockPosition4);

diagonalKeyAngleCw = ((keyAngle - 180) % 360) + bitAngle;
diagonalKeyAngleCcw = ((keyAngle - 180) % 360) - bitAngle;
//echo(lockEnteringAngle = lockEnteringAngle);
//echo(diagonalKeyAngleCw = diagonalKeyAngleCw);
//echo(diagonalKeyAngleCcw = diagonalKeyAngleCcw);

turnDisplacementCw = bitDiagonal*sin(diagonalKeyAngleCw);
turnDisplacementCcw = bitDiagonal*sin(diagonalKeyAngleCcw);
//echo(turnDisplacementCw = turnDisplacementCw);
//echo(turnDisplacementCcw = turnDisplacementCcw);

latchDisplacement =
  workRegion == toClosing1 ? lockPosition1 :
  workRegion == closing1   ? lockPosition1 + turnDisplacementCw - bitWidth/2:
  workRegion == toClosing2 ? lockPosition2 :
  workRegion == closing2   ? lockPosition4 + turnDisplacementCw - bitWidth/2 :
  workRegion == closed     ? lockPosition3 :
  workRegion == toOpening2 ? lockPosition3 :
  workRegion == opening2   ? lockPosition3 + turnDisplacementCcw + bitWidth/2 :
  workRegion == toOpening1 ? lockPosition4 :
  workRegion == opening1   ? lockPosition2 + turnDisplacementCcw + bitWidth/2 :
                             lockPosition1;

                                                   // position lock displacement
diagonalKeyAngle2 = 
  keyAngle % 360 < 180 ? 180 - (keyAngle % 360) - bitAngle
                       : 180 - (keyAngle % 360) + bitAngle;

lockerDisplacement = bitDiagonal*cos(diagonalKeyAngle2)
  - (bitHeight - verticalBitLatchDepth);

latchLockerDisplacement =
  keyAngle % 360 <= lockEnteringAngle ? 0 :
  keyAngle % 360 <= lockExitedAngle   ? lockerDisplacement :
                                        0;

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
                                                                         // lock
module lock() {
                                                                 // bottom plate
  bottomPlate();
                                                                // position lock
  translate([
    keyholeX,
    latchTop - latchPlateWidth + latchLockerDisplacement,
    lockPlateHeight
  ])
    latchLocker();
                                                                        // latch
  translate([lockPlateLength, lockPlateWidth/2, lockHeight/2])
    latch();
                                                           // latch plate holder
  translate([
    latchHolderLength,
    latchTop - latchPlateWidth/2,
    latchBottom + latchPlateHeight + latchMargin
  ])
    latchPlateTopHolder(showLatchPlateTopHolder);
                                                                       // spring
  translate([
    keyholeX,
    latchTop + latchSlitDepth,
    springHeight
  ])
    holderSpring();
                                                                    // top plate
  if (showTopPlate) {
    translate([0, 0, lockHeight - lockPlateHeight])
      topPlate();
  }
}

//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\\
                                                                 // bottom plate
module bottomPlate(renderIt=true) {
  if (renderIt) {
    difference() {
      union() {
        color("LightSlateGray")
          difference() {
                                                                        // plate
            cube(
              [lockPlateLength, lockPlateWidth, lockPlateHeight],
            center=false);
                                                               // key shaft hole
            translate([keyholeX, keyholeY + bitMargin, 0])
              cylinder(d=keyholeDiameter, h=3*lockPlateHeight, center=true);
                                                                 // key bit hole
            translate([keyholeX, keyholeY + bitMargin, -lockPlateHeight])
              linear_extrude(height=3*lockPlateHeight)
                offset(delta=bitMargin)
                  polygon(points=bitShape);
          }
                                                         // top and bottom walls
        color("Silver") {
          if (renderForPrint || showSideWalls) {
            for (yOffset = [0, lockPlateWidth - lockPlateHeight])
              translate([0, yOffset, 0])
                cube(
                  [lockPlateLength, lockPlateHeight, lockHeight],
                center=false);
          }
                                                      // bolt opposite side wall
          if (renderForPrint || showBackWall) {
            cube([lockPlateHeight, lockPlateWidth, lockHeight], center=false);
          }
                                                               // bolt side wall
          translate([lockPlateLength - lockPlateHeight, 0, 0])
            difference() {
              union() {
                cube(
                  [lockPlateHeight, lockPlateWidth, lockHeight],
                center=false);
                translate([
                  -latchBoltGuideLength,
                  lockPlateWidth/2 - latchBoltWidth/2 - latchBoltGuideLength,
                  0
                ])
                  cube([
                    latchBoltGuideLength + lockPlateHeight,
                    latchBoltWidth + 2*latchBoltGuideLength,
                    lockHeight - lockPlateHeight
                  ], center=false);
              }
              translate([0, lockPlateWidth/2, lockHeight/2])
                cube([
                  latchBoltLength,
                  latchBoltWidth + latchMargin,
                  latchBoltHeight + latchMargin
                ], center=true);
            }
        }
                                                                // screw pillars
        color("SlateGray")
          for (xOffset = [
            screwHolesDistanceX, lockPlateLength - screwHolesDistanceX
          ])
            for (yOffset = [
              screwHolesDistanceY, lockPlateWidth - screwHolesDistanceY
            ])
              translate([xOffset, yOffset, 0])
                cylinder(
                  d=screwHolesDiameter + 2*lockPlateHeight,
                  h=lockHeight-lockPlateHeight,
                  center=false
                );
                                                           // latch plate holder
        color("LightGrey")
          latchPlateBottomHolder();
                                             // slider for latch position locker
        color("Grey")
          difference() {
            translate([
              keyholeX,
              lockPlateWidth/2,
              sliderHeight/2
            ])
              cube([
                bitHeight,
                lockPlateWidth,
                sliderHeight
              ], center=true);
            translate([
              keyholeX,
              latchBoltWidth/2 - latchPlateWidth + latchSlitDepth,
              0
            ])
              cube([2*bitHeight, lockPlateWidth, lockHeight], center=true);
          }
                                                                 // spring stops
        color("DarkSlateGray")
          for (xOffset = [-3/8*springLength, 3/8*springLength])
            translate([
              keyholeX + xOffset,
              latchTop + latchSlitDepth + springStopDiameter/2 - springDiameter/2,
              0
            ]) {
              cylinder(d=springStopDiameter, h=springHeight + springDiameter);
              translate([0, 0, springHeight])
                cylinder(
                  d1=springStopDiameter,
                  d2=springStopDiameter+2*springDiameter,
                  h=2*springDiameter
                );
            }
                                                                    // bit notch
//        if (addBitSlit) {
        if (false) {
          color("LightGoldenrodYellow")
            translate([
              keyholeX - bitHeight - 3*lockPlateHeight,
              keyholeY - bitWidth/2,
              0
            ]) {
              cube([lockPlateHeight, bitWidth, lockHeight/2], center=false);
              translate([0, 0, (lockHeight - bitSlitWidth)/2])
                cube([bitSlitDepth, bitWidth, bitSlitWidth], center=false);
            }
        }
      }
                                                                  // screw holes
      color("SlateGray")
        for (xOffset = [
          screwHolesDistanceX, lockPlateLength - screwHolesDistanceX
        ])
          for (yOffset = [
            screwHolesDistanceY, lockPlateWidth - screwHolesDistanceY
          ])
            translate([xOffset, yOffset, 0]) {
                                                                    // cylinders
              cylinder(d=screwHolesDiameter, h=2*lockHeight, center=true);
                                                                        // cones
              cylinder(
                d1=screwHolesDiameter+4*screwHolesConeHeight,
                d2=screwHolesDiameter,
                h=2*screwHolesConeHeight,
                center=true
              );
            }
    }
  }
}

//----------------------------------------------------------------------------\\
                                                                    // top plate
module topPlate(renderIt=true) {
  if (renderIt) {
    color("LightSteelBlue")
                                                                        // plate
      difference() {
        translate([lockPlateHeight, lockPlateHeight, 0])
          cube([
            lockPlateLength - 2*lockPlateHeight,
            lockPlateWidth - 2*lockPlateHeight,
            lockPlateHeight
          ], center=false);
                                                                  // screw holes
        for (xOffset = [
          screwHolesDistanceX, lockPlateLength - screwHolesDistanceX
        ])
          for (yOffset = [
            screwHolesDistanceY, lockPlateWidth - screwHolesDistanceY
          ])
                                                                    // cylinders
            translate([xOffset, yOffset, 0]) {
              cylinder(d=screwHolesDiameter, h=3*lockPlateHeight, center=true);
                                                                        // cones
              translate([0, 0, lockPlateHeight])
                cylinder(
                  d1=screwHolesDiameter,
                  d2=screwHolesDiameter+4*screwHolesConeHeight,
                  h=2*screwHolesConeHeight,
                  center=true
                );
            }
                                                               // key shaft hole
        translate([keyholeX, keyholeY + bitMargin, 0])
          cylinder(d=keyholeDiameter, h=3*lockPlateHeight, center=true);
                                                                 // key bit hole
        translate([keyholeX, keyholeY + bitMargin, 2*lockPlateHeight])
          rotate([0, 180, 0])
            linear_extrude(height=3*lockPlateHeight)
              offset(delta=bitMargin)
                polygon(points=bitShape);
      }
  }
}

//----------------------------------------------------------------------------\\
                                                                        // latch
module latch(renderIt=true) {
  if (renderIt) {

//############################################################################\\
//############################################################################\\
//############################################################################\\

    translate([latchDisplacement, 0, 0]) {
                                                                         // bolt
      color("Goldenrod")
        translate([-latchBoltLength/2, 0, 0])
          cube([latchBoltLength, latchBoltWidth, latchBoltHeight], center=true);
                                                                        // plate
      color("DarkGoldenrod")
        difference() {
          translate([
            -latchPlateLength/2,
            (latchBoltWidth - latchPlateWidth)/2,
            -(latchBoltHeight - latchPlateHeight)/2
          ])
            cube(
              [latchPlateLength, latchPlateWidth, latchPlateHeight],
            center=true);
                                                                        // slits
          for (slitOffset = slitOffsets)
            translate([
              -slitOffset,
              latchBoltWidth/2 - latchPlateWidth - latchSlitDepth,
              -lockHeight/2
            ])
              cube([latchSlitLength, 2*latchSlitDepth, lockHeight], center=false);
                                                               // V-lock cutouts
          for (xOffset =
            [lockPosition1, lockPosition2, lockPosition3, lockPosition4]
          )
            translate([
              -(lockPlateLength - keyholeX + xOffset) + lockPosition1,
              latchPlateWidth - latchMargin,
              -latchBoltHeight/2 - lockPlateHeight/2
            ])
              latchVHolder();
                                                        // inter- V-locks cutout
//          translate([
//            -keyholeX - (lockPosition4 - lockPosition2) + 2*latchMargin,
//            latchPlateWidth
//              - minLatchSlitDepth + (bitDiagonal - bitHeight),
//            -lockHeight/2
//          ])
//            cube(
//              [lockPosition4 - lockPosition2, latchPlateWidth, lockHeight],
//            center = false);
                                                                 // guiding slit
          guidingSlitOffsetX = -lockPlateLength + latchHolderLength
            - latchPlateGuideWidth/2;
          guidingSlitlength = lockPosition3 - lockPosition1;
          for (addLength = [0, 1])
            translate([
              guidingSlitOffsetX - addLength*guidingSlitlength,
              latchBoltWidth/2 - latchPlateWidth/2,
              0
            ])
              cylinder(
                d=latchPlateGuideWidth + latchMargin,
                h=lockHeight,
                center=true
              );
            translate([
              guidingSlitOffsetX - guidingSlitlength/2,
              latchBoltWidth/2 - latchPlateWidth/2,
              -lockHeight/4
            ])
              cube([
                guidingSlitlength,
                latchPlateGuideWidth + latchMargin,
                lockHeight
              ], center=true);
        }
      }
  }
}

//----------------------------------------------------------------------------\\
                                                    // latch plate bottom holder
module latchPlateBottomHolder() {
                                                                // guiding plate
  translate([0, latchTop - latchPlateWidth/2 - latchPlateGuideWidth, 0])
    cube(
      [latchHolderLength, 2*latchPlateGuideWidth, latchBottom],
    center=false);
                                                                  // guiding rod
  translate([
    latchHolderLength - latchPlateGuideWidth/2,
    latchTop - latchPlateWidth/2,
    0
  ])
    cylinder(
      d=latchPlateGuideWidth, h=(lockHeight+latchBoltHeight)/2,
    center=false);
}

//----------------------------------------------------------------------------\\
                                                       // latch plate top holder
module latchPlateTopHolder(renderIt=true) {
  if (renderIt) {
  holderHeight = (lockHeight + latchBoltHeight)/2 - latchPlateHeight
    - latchMargin;
  color("Gainsboro")
    translate([-latchPlateGuideWidth/2, 0, 0]) {
                                                               // outer cylinder
        difference() {
          cylinder(
            d=2*latchPlateGuideWidth,
            h=lockHeight - latchBottom - latchPlateHeight 
              - lockPlateHeight - latchMargin,
            center=false
          );
                                                                // internal hole
          cylinder(
            d=latchPlateGuideWidth + latchMargin,
            h=2*lockHeight,
            center=true
          );
      }
    }
  }
}

//----------------------------------------------------------------------------\\
                                                        // latch position locker
module latchLocker(renderIt=true) {
  if (renderIt) {
    difference() {
      union() {
        color("DarkSalmon")
          difference() {
                                                                   // main piece
            translate([-bitHeight, 0, 0])
              cube([
                latchLockerWidth,
                latchPlateWidth + latchSlitDepth,
                latchBottom - lockPlateHeight - latchMargin
              ], center=false);
                                                                 // guiding hole
            cube([
              bitHeight + latchMargin,
              lockPlateWidth,
              sliderHeight + lockPlateHeight
            ], center=true);
                                                        // guiding hole openings
            for (xOffset = [-bitHeight/2, bitHeight/2])
              translate([xOffset, latchPlateWidth + latchSlitDepth, 0])
                rotate([0, 0, 45])
                  cube([
                    2*latchMargin,
                    2*latchMargin,
                    sliderHeight + lockPlateHeight
                  ], center=true);
          }
                                                                    // back side
        color("Salmon")
          translate([
            -bitHeight,
            latchPlateWidth + latchSlitDepth - springDiameter,
            sliderHeight - lockPlateHeight + 2*latchMargin
          ])
            cube([
              2*bitHeight,
              springDiameter,
              springDiameter + 2*latchMargin
            ], center=false);
                                                               // V-shape holder
        color("LightSalmon")
          translate([
            0,
            latchPlateWidth + 2*latchMargin,
            latchBottom - lockPlateHeight - 2*latchMargin
          ])
            latchVHolder();
        }
                                                                 // spring guide
      color("IndianRed")
        translate([
          0,
          latchPlateWidth + latchSlitDepth,
          sliderHeight + springDiameter/2 - latchMargin
        ])
          rotate([0, 90, 0])
            cylinder(
              d=springDiameter + 2*latchMargin,
              h=3*bitHeight,
              center=true
            );
    }
  }
}

//----------------------------------------------------------------------------\\
                                                         // latch V-shape holder
module latchVHolder() {
  y1 = minLatchSlitDepth;
  y2 = -minLatchSlitDepth + (bitDiagonal - bitHeight) + bitMargin;
  backWidth = 2*(y1-y2)*tan(latchVHolderSideAngle);
  linear_extrude(height=latchPlateHeight+lockPlateHeight)
    polygon([
      [-backWidth/2,  y1],
      [ 0,            y2],
      [ backWidth/2,  y1]
    ]);
}

//============================================================================\\
                                                     // spring to V-shape holder
module holderSpring() {
  scaleYZ = 4*(2*latchLockerDisplacement + 1);
  color("Black")
    for (side = [-1, 1]) {
      difference() {
        translate([0, latchLockerDisplacement - 2*scaleYZ, 0])
          scale([side*springLength/2, scaleYZ, scaleYZ])
            rotate_extrude(angle=90)
              translate([2, 0, 0])
                circle(r = springDiameter/2/scaleYZ);
        translate([side*springLength, 0, 0])
          cube([springLength, 2*springLength, springLength], center=true);
      }
    }
//  cylinder(d=springDiameter, h=springLength, center=true);
}

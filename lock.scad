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
                                                                       // screws
screwHolesDiameter = 5;
screwHolesDistanceX = 12;
screwHolesDistanceY = 8;
                                                                       // spring
springDiameter = 1;
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
topPositionLatchSlitDepth = (keyholeY + bitHeight)
  - (latchTop - latchPlateWidth);
bitStartAngle = acos(1 - topPositionLatchSlitDepth/bitHeight);
minLatchSlitDepth = topPositionLatchSlitDepth + bitWidth/2*sin(bitAngle);
latchSlitDepth = minLatchSlitDepth + bitMargin;
latchSlitLength = 19 + bitMargin;

firstSlitOffset = lockPlateLength + latchSlitLength - keyholeX - bitWidth/2;
secondSlitOffset = 27;
slitOffsets = [firstSlitOffset, firstSlitOffset + secondSlitOffset];

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
printTopPlate = false;
printLatch = true;
printLatchLocker = true;
printLatchPlateTopHolder = true;
printKey = false;
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
    bowTorusDiameter + bowTorusTubeThinDiameter/2,
    lockPlateWidth + latchBoltWidth + bowTorusDiameter + printDistance,
    bowBallDiameter/2
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

//############################################################################\\
//############################################################################\\
//############################################################################\\

fixedPosition = 2;
animate = false;  // FPS: 10, Steps: 40

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

function animationPosition(t) = t < 3/4 ? len(specificKeyAngles)*4/3*t : 0;
position = animate ? animationPosition($t) : fixedPosition;
echo(position = position);
keyAngle = specificKeyAngles[position];
                                                           // latch displacement
turnHeight = bitHeight/cos(bitAngle);
lockPosition2 = -turnHeight*sin(lockExitingAngle);
lockPosition3 = secondSlitOffset + lockPosition2;
lockPosition4 = lockPosition3 - latchSlitLength + lockPosition2;
lockPosition1 = lockPosition2 - lockPosition3 + lockPosition4;

diagonalKeyAngle1 = 
  keyAngle % 360 > 180 ? (keyAngle % 360) + bitAngle -180
                       : 180 - (keyAngle % 360) + bitAngle;
echo(keyAngle = (keyAngle-180));
echo(diagonalKeyAngle1 = diagonalKeyAngle1);

singleTurnDisplacement = turnHeight*sin(diagonalKeyAngle1);

latchDisplacement =
  clockwise ?
    keyAngle <= 180                     ? lockPosition1 :
    keyAngle <= lockExitingAngle        ? singleTurnDisplacement - bitWidth/2 :
    keyAngle <= 360 + lockEnteringAngle ? lockPosition2 :
    keyAngle <= 360 + 180               ? secondSlitOffset
                                        - singleTurnDisplacement + bitWidth/2 :
    keyAngle <= 360 + lockExitingAngle  ? secondSlitOffset
                                        + singleTurnDisplacement - bitWidth/2 :
                                          lockPosition3
  :
    keyAngle >= 360 + 180               ? lockPosition3 :
    keyAngle >= 360 + lockEnteredAngle  ? secondSlitOffset + latchSlitLength
                                          - singleTurnDisplacement
                                          - bitWidth/2 :
    keyAngle >= lockExitedAngle         ? lockPosition4 :
    keyAngle >= 180                     ? secondSlitOffset - latchSlitLength
                                          + singleTurnDisplacement :
    keyAngle >= lockEnteredAngle        ? latchSlitLength - bitWidth/2
                                          - singleTurnDisplacement :
                                          lockPosition1;

                                                   // position lock displacement
diagonalKeyAngle2 = 
  keyAngle % 360 < 180 ? 180 - (keyAngle % 360) - bitAngle
                       : 180 - (keyAngle % 360) + bitAngle;

lockerDisplacement = turnHeight*cos(diagonalKeyAngle2)
  - (bitHeight - topPositionLatchSlitDepth);

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
        if (addBitSlit) {
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
//############################################################################\\
//############################################################################\\
//############################################################################\\

      }
                                                                  // screw holes
      color("SlateGray")
        for (xOffset = [
          screwHolesDistanceX, lockPlateLength - screwHolesDistanceX
        ])
          for (yOffset = [
            screwHolesDistanceY, lockPlateWidth - screwHolesDistanceY
          ])
            translate([xOffset, yOffset, 0])
              cylinder(
                d=screwHolesDiameter,
                h=2*lockHeight,
                center=true
              );
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
            translate([xOffset, yOffset, 0])
              cylinder(d=screwHolesDiameter, h=3*lockPlateHeight, center=true);
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
    translate([latchDisplacement - lockPosition1, 0, 0]) {
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
          translate([
            -keyholeX + lockPosition1
              - (lockPosition4 - lockPosition2) - latchMargin,
            latchPlateWidth
              - minLatchSlitDepth + (turnHeight - bitHeight),
            -lockHeight/2
          ])
            cube(
              [lockPosition4 - lockPosition2, latchPlateWidth, lockHeight],
            center = false);
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
                2*bitHeight,
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
            latchPlateWidth + latchSlitDepth/2,
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
  linear_extrude(height=latchPlateHeight+lockPlateHeight)
    polygon([
      [-minLatchSlitDepth/2,  minLatchSlitDepth],
      [0, -minLatchSlitDepth + (turnHeight - bitHeight) + latchMargin],
      [ minLatchSlitDepth/2,  minLatchSlitDepth]
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
                circle(r = 1/2/scaleYZ);
        translate([side*springLength, 0, 0])
          cube([springLength, 2*springLength, springLength], center=true);
      }
    }
//  cylinder(d=springDiameter, h=springLength, center=true);
}

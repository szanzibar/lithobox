// lithobox
// Inspirations:
// - https://www.thingiverse.com/thing:3755803
// - https://lithophanemaker.com/Lithophane%20Light%20Box.html
// - https://itslitho.com

// https://github.com/tbuser/pin_connectors/blob/master/pins.scad
use <pins.scad>

// Adjustable constants

// Lithopane side size. (must be a square)
lithSize = 120; //[100:1:200]

// Lithopane Thickness
lithThickness = 3; //[0.8:.2:10]

// Lithopane Border size (determines inset depth)
lithBorderWidth = 2; //[1:.2:8]

// size of the lip between outer edge and lithophane panel
lipSize = 2; //[1.8:.2:10]

// Hole for lightbulb to fit into
backPanelHoleRadius = 18; //[1:.1:30]

// Text to put on back panel
showText = false;

line1 = "The";
line2 = "Quick";
line3 = "Brown";

line4 = "Fox";
line5 = "Jumped";
line6 = "Real High";

// Real constants

borderThickness = lipSize + lithThickness + lipSize + lithBorderWidth;
// borderThickness = 9

floorThickness = 5;

innerThickness = lipSize * 2 + lithThickness;
// innerThickness = 7

pillarHeight = lithSize - lithBorderWidth * 2;
pinCorner = lithSize / 2 + innerThickness / 2;
// pinCorner = 60 + 3.5

pinHeight = 5;
pinRadius = 2.5;

module
myPin()
{
    color("RoyalBlue") pin(h = pinHeight, r = pinRadius);
}

module
myPinHole()
{
    color("RoyalBlue") pinhole(h = pinHeight, r = pinRadius, tight = false);
}

module
pillar()
{
    pillarPinCorner = pinCorner + innerThickness / 2 - borderThickness / 2;

    translate([ pillarPinCorner, pillarPinCorner, 0 ])
        cube([ borderThickness, borderThickness, pillarHeight ], true);
    translate([ pinCorner, pinCorner, pillarHeight / 2 - 1 ]) myPin();
    translate([ pinCorner, pinCorner, -pillarHeight / 2 + 1 ])
        rotate([ 0, 180, 0 ]) myPin();
}

module
pillarWithPanels()
{
    difference()
    {
        translate([ 0, 0, -1 ]) pillar();
        panels(top = true);
    }
}

module
base()
{
    outerBaseSize = lithSize + innerThickness * 2;
    innerBaseSize = lithSize;

    difference()
    {
        translate([ -outerBaseSize / 2, -outerBaseSize / 2, 0 ])
            cube([ outerBaseSize, outerBaseSize, borderThickness ], false);
        translate(
            [ -innerBaseSize / 2, -innerBaseSize / 2, floorThickness + 0.1 ])
            cube([ lithSize, lithSize, borderThickness - floorThickness ],
                 false);
    }
}

module topBase(height)
{
    outerBaseSize = lithSize + innerThickness * 2;
    stiffUpperLip = lithSize - lipSize * 2;

    difference()
    {
        translate([ -outerBaseSize / 2, -outerBaseSize / 2, 0 ])
            cube([ outerBaseSize, outerBaseSize, height ], false);
        translate([ -stiffUpperLip / 2, -stiffUpperLip / 2, -1 ])
            cube([ stiffUpperLip, stiffUpperLip, height + floorThickness * 2 ],
                 false);
    }
}

module panels(bufferOn = true, top = false)
{
    buffer = bufferOn ? 0.4 : 0;
    height = top ? lithSize : lithThickness;
    x = lithSize / 2 + innerThickness / 2;
    z = top ? -lithBorderWidth
            : borderThickness + lithThickness / 2 - lithBorderWidth;

    translate([ 0, -x, z ]) rotate([ 90, 0, 0 ]) panel(height, buffer);
    translate([ 0, x, z ]) rotate([ 90, 0, 0 ]) panel(height, buffer);
    translate([ -x, 0, z ]) rotate([ 90, 0, 90 ]) panel(height, buffer);
    translate([ x, 0, z ]) rotate([ 90, 0, 90 ]) panel(height, buffer);
}

module panel(height, buffer)
{
    color("Plum")
        cube([ lithSize + buffer, height, lithThickness + buffer ], true);
}

module internalPanels(pw, ph, pd)
{
    translate([ 0, 0, pd / 2 ]) color("green")
        cube([ pw + 0.4, ph + 0.4, pd + 0.4 ], true);
}

module
top()
{
    height = borderThickness - lipSize;
    pinHoleDepth = height - pinHeight;

    difference()
    {
        topBase(height);

        translate([ pinCorner, pinCorner, pinHoleDepth ]) myPinHole();
        translate([ -pinCorner, pinCorner, pinHoleDepth ]) myPinHole();
        translate([ pinCorner, -pinCorner, pinHoleDepth ]) myPinHole();
        translate([ -pinCorner, -pinCorner, pinHoleDepth ]) myPinHole();

        panels(top = true);
        internalPanels(lithSize, lithSize, lithThickness + 0.4);
    };
}

module
bottom()
{
    pinHoleDepth = borderThickness - pinHeight;

    difference()
    {
        base();
        translate([ pinCorner, pinCorner, pinHoleDepth ]) myPinHole();
        translate([ -pinCorner, pinCorner, pinHoleDepth ]) myPinHole();
        translate([ pinCorner, -pinCorner, pinHoleDepth ]) myPinHole();
        translate([ -pinCorner, -pinCorner, pinHoleDepth ]) myPinHole();

        panels();
    };
}

module
backPanel()
{
    difference()
    {
        cube([ lithSize, lithSize, lithThickness ], true);
        cylinder(lithThickness * 2, r = backPanelHoleRadius, center = true);
        translate([ 0, 0, lithThickness / 2 - 0.4 ]) color("blue")
            linear_extrude(1) myText();
    }
}

module
myText()
{
    if (showText == true)
    {
        textOffset = (lithSize / 2 - backPanelHoleRadius) / 4;

        fontsize = 5;

        fontname = "Microsoft Sans Serif";
        translate([ 0, backPanelHoleRadius + textOffset * 3, 0 ])
            text(line1,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);
        translate([ 0, backPanelHoleRadius + textOffset * 2, 0 ])
            text(line2,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);
        translate([ 0, backPanelHoleRadius + textOffset, 0 ])
            text(line3,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);

        translate([ 0, -backPanelHoleRadius - textOffset, 0 ])
            text(line4,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);
        translate([ 0, -backPanelHoleRadius - textOffset * 2, 0 ])
            text(line5,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);
        translate([ 0, -backPanelHoleRadius - textOffset * 3, 0 ])
            text(line6,
                size = fontsize,
                halign = "center",
                valign = "center",
                font = fontname);
        
    }
}

module
topCover()
{
    topBase(lipSize);
    translate([ 0, 0, -borderThickness + lithBorderWidth + lithThickness - 1 ])
        panels(bufferOn = false);
}

module
print_part()
{
    bottom();
    translate([ lithSize * 1.5, 0, borderThickness - lithThickness ])
        rotate([ 180, 0, 0 ]) top();
    translate([ 0, lithSize * 1.5, pinCorner + innerThickness / 2 ])
        rotate([ 90, 180, 0 ]) pillarWithPanels();
    translate([ lithSize * 1.5, lithSize * 1.5, 0 ]) backPanel();
    translate([ borderThickness * 3, lithSize * 1.5, 0 ]) topCover();

    // bottom();
    // rotate([ 180, 0, 0 ]) top();
    // for (i=[0,1,2,3]) translate([borderThickness * 2 * i + borderThickness * 4, 0, pinCorner + innerThickness / 2]) rotate([ 90, 180, 0 ]) pillarWithPanels();
    // backPanel();
    // topCover();
}

print_part();

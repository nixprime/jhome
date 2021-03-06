jcolor Reference
================

We use the D65 illuminant at 10 degrees throughout.

jcolor-dark
-----------

WCAG 2.0 accessibility requirements: Level AA requires a luminosity contrast
ratio of 4.5:1 for small text and 3:1 large text. Level AAA requires a contrast
ratio of 7:1 for small text and 4.5:1 for large text. Large text is text above
18pt, or bold and above 14pt. Normal foreground text is required to meet level
AAA; de-emphasized foreground text and highlight colors are required to meet
level AA.

AERT accessibility requirements: Brightness difference >= 125, color difference
>= 500. Satisfying one is acceptable, but satisfying both is better. Normal
foreground text is required to satisfy both.

Highlight colors are selected to be approximately equidistant in the (a, b)
plane from grey (0, 0): approximately 70 units. Highlight colors also have
their luminances chosen to be within 5 units of the luminance of de-emphasized
text.

* Background (normal): L=12, a=0, b=0 => #1f201f
  Very dark neutral grey.

* Background (highlight): L=5, a=0, b=0 => #111111
  Very, very dark neutral grey.

* Background (weak): L=19, a=0, b=0 => #2e2e2e

* Background (very weak): L=26, a=0, b=0 => #3e3e3d

* Normal-highlight border: L=25, a=0, b=0 => #3b3b3b

* Foreground (normal): L=88, a=-5, b=-5 => #cee0e4
  Light grey, tinted slightly blue to soften and improve contrast with other
  colors.

* Foreground (de-emphasized): L=68, a=-5, b=-5 => #97a9ad
  Medium grey, tinted slightly blue.

* Foreground (weak): L=33, a=-5, b=-5 => #405055
  Dark grey, tinted slightly blue.

* Red: L=63, a=56, b=42 => #fe6850

* Orange: L=68, a=37, b=60 => #e87b28

* Yellow: L=73, a=-15, b=68 => #bbb924

* Green: L=68, a=-54, b=44 => #49bc50

* Blue: L=68, a=14, b=-69 => #4ba5ff

* Purple: L=68, a=53, b=-45 => #dc82f6

jcolor-light
------------

The same principles hold as in jcolor-dark. However, the problem is complicated
somewhat by the difficulty in detecting luminance differences between black and
"dark grey" text.

We omit yellow, since there is no way to have clearly visible yellow text on an
off-white background.

* Background (normal): L=88, a=0, b=7 => #e2dcce
  Very light grey, tinted slightly yellow.

* Background (highlight): L=95, a=0, b=7 => #f7f0e1
  Off-white.

* Normal-highlight border: L=72, a=0, b=7 => #b6b0a2

* Foreground (normal): #000000
  Solid black.

* Foreground (de-emphasized): L=35, a=0, b=0 => #525252
  Grey.

* Red: L=35, a=56, b=42 => #a51110

* Orange: L=40, a=37, b=60 => #a14100

* Green: L=40, a=-54, b=44 => #007001

* Blue: L=35, a=14, b=-69 => #0053c1

* Purple: L=35, a=53, b=-45 => #7f2a9a

jcolor-series
-------------

For series colors, the two most important properties are:

* Salience. Each color should be more or less unambiguously nameable.

* Alternating contrast. Series should alternate in luminance to facilitate
  printing.

From Heer & Stone's color name model work, we choose the following (a, b)
coordinates and L ranges for our 9 base colors:

* Red: (80, 60)

* Orange: (40, 65)

* Yellow: (-20, 90); L > 80

* Green: (-55, 45)

* Blue: (15, -75)

* Purple: (65, -55)

* Pink: (70, -30)

* Brown: (15, 35)

* Grey: (0, 0)

Based on these L ranges, we classify red, blue, purple, and brown as "dark
colors" and orange, green, pink, grey, and yellow as "light colors". Yellow is
excluded since its luminance range is so limited. We then arbitrarily choose
blue as our first color by appeal to tradition. Ordering the remaining colors
to maximize color contrast differences while alternating luminance contrast,
we select a color order of blue, orange, purple, green, red, pink, brown, grey.

jcolor-figure
-------------

We must be able to produce an arbitrary number of colors for a given luminance.
To do this, we fix a distance from the (a, b) origin and choose angles based on
the low-discrepancy van der Corput sequence.

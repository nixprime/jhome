#!/usr/bin/env python

from __future__ import print_function

import math

# xyY chromaticity/luminance coordinates for illuminants.
ILLUMINANT_D50_2 = (0.34567, 0.35850, 1.0)
ILLUMINANT_D50_10 = (0.34773, 0.35952, 1.0)
ILLUMINANT_D65_2 = (0.31271, 0.32902, 1.0)
ILLUMINANT_D65_10 = (0.31382, 0.33100, 1.0)

# Constants for internal use.
L_SERIES = [20, 60, 30, 70, 40, 80, 50, 90]
AB_SERIES = [
        (15, -75),  # blue
        (40, 65),   # orange
        (65, -55),  # purple
        (-55, 45),  # green
        (80, 60),   # red
        (70, -30),  # pink
        (15, 35),   # brown
        #(0, 0),     # grey
        (-20, 90),  # yellow
        ]
L_FIG_FILL = 75.0
L_FIG_LINE = 55.0
R_FIG = 40.0
THETA_0_FIG = -0.5*math.pi
VDC_BASE_FIG = 3

def series_color(i):
    """Choose a color for the (i+1)th series in a plot where series are
    qualitatively distinctive. Colors will repeat starting with i=8. Returns a
    color in the form #rrggbb."""
    l = L_SERIES[i % len(L_SERIES)]
    (a, b) = AB_SERIES[i % len(AB_SERIES)]
    return lab_to_hex((l, a, b))

def series_colors(n):
    """Choose colors for n series in a plot where series are qualitatively
    distinctive. n should be at most 8. Returns a list of colors in the form
    #rrggbb."""
    return [series_color(i) for i in range(n)]

def fig_fill_color(i):
    """Choose a background fill color for the (i+1)th element in a figure.
    Returns a color in the form #rrggbb."""
    return fig_color(i, L_FIG_FILL)

def fig_line_color(i):
    """Choose a color for the (i+1)th line in a figure. Returns a color in the
    form #rrggbb."""
    return fig_color(i, L_FIG_LINE)

def fig_color(i, l):
    """Helper function for fig_fill_color and fig_line_color."""
    def choose_ab(i, a_0=0.0, b_0=0.0, r=R_FIG, theta_0=THETA_0_FIG,
            base=VDC_BASE_FIG):
        theta = theta_0 + van_der_corput(i, base) * 2.0 * math.pi
        delta_a = r * math.cos(theta)
        delta_b = r * math.sin(theta)
        return (a_0 + delta_a, b_0 + delta_b)

    (a, b) = choose_ab(i)
    return lab_to_hex((l, a, b))

def lab_to_hex(lab, illuminant=ILLUMINANT_D65_10):
    """Given a color in the CIELAB space and an illuminant in the CIE xyY
    chromaticity/luminance space, return a string of the form #rrggbb
    representing that color in sRGB."""
    return rgb_as_hex(xyz_to_srgb(lab_to_xyz(lab, xyy_to_xyz(illuminant))))

def xyy_to_xyz(xyy):
    """Given a color in the CIE xyY chromaticity/luminance space, calculate
    the CIEXYZ representation of the same color."""
    x = xyy[2] * xyy[0] / xyy[1]
    z = xyy[2] * (1 - xyy[0] - xyy[1]) / xyy[1]
    return (x, xyy[2], z)

def lab_to_xyz(lab, wp):
    """Given a color in the CIELAB space and a white point CIEXYZ tristimulus,
    calculate the CIEXYZ representation of the same color."""
    def finv(t):
        if (t > 6.0/29.0):
            return t**3.0
        else:
            return 3.0 * (6.0/29.0)**2 * (t - 4.0/29.0)

    temp = (lab[0] + 16.0) / 116.0
    y = wp[1] * finv(temp)
    x = wp[0] * finv(temp + lab[1]/500.0)
    z = wp[2] * finv(temp - lab[2]/200.0)
    return (x, y, z)

def xyz_to_srgb(xyz):
    """Given a color in the CIEXYZ space, calculate the sRGB representation of
    the same color."""
    (x, y, z) = xyz
    rl =  3.2406 * x - 1.5372 * y - 0.4986 * z
    gl = -0.9689 * x + 1.8758 * y + 0.0415 * z
    bl =  0.0557 * x - 0.2040 * y + 1.0570 * z

    def linear_to_srgb(c):
        # Clamp to [0, 1]
        if c < 0.0:
            c = 0.0
        elif c > 1.0:
            c = 1.0
        if c <= 0.0031308:
            return 12.92 * c
        else:
            return 1.055 * (c**(1.0/2.4)) - 0.055

    r = linear_to_srgb(rl)
    g = linear_to_srgb(gl)
    b = linear_to_srgb(bl)
    return (r, g, b)

def rgb_as_hex(rgb):
    """Given a color in RGB color representation, return a string of the form
    #rrggbb representing that color."""
    def rah(c):
        c255 = int(round(c * 255.0))
        if c255 < 0:
            c255 = 0
        elif c255 > 255:
            c255 = 255
        # Skip the 0x and pad to 2 characters
        return ("00" + hex(c255)[2:])[-2:]

    (r, g, b) = rgb
    return "#" + rah(r) + rah(g) + rah(b)

def van_der_corput(n, base=2):
    """Returns the nth element of the van der Corput sequence with the given
    base."""
    vdc, denom = 0.0, 1.0
    while n:
        denom *= base
        n, rem = divmod(n, base)
        vdc += rem / denom
    return vdc

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Syntax: jcolor (number of colors)")
        sys.exit(1)
    ncolors = int(sys.argv[1])
    if (ncolors < 1):
        print("Invalid number of colors:", ncolors)
        sys.exit(1)

    print("Graph colors:")
    for i in range(ncolors):
        print(series_color(i))

    print("Figure background colors:")
    for i in range(ncolors):
        print(fig_fill_color(i))

    print("Figure line colors:")
    for i in range(ncolors):
        print(fig_line_color(i))

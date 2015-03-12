#!/usr/bin/env python

from __future__ import print_function

import math
import sys

class LABColor(object):
    """Represents a color in the CIE LAB color space."""

    def __init__(self, L, a, b):
        self.L = L
        self.a = a
        self.b = b

    def to_xyz(self, wp_xyz=None):
        """Converts the color to CIE XYZ representation.

        Args:
            wp_xyz: XYZColor: Illuminant white point.

        Returns:
            XYZColor object.
        """
        if wp_xyz is None:
            wp_xyz = ILLUMINANT_D65_10
        def finv(t):
            if t > (6.0 / 29.0):
                return t ** 3.0
            return 3.0 * ((6.0 / 29.0) ** 2) * (t - 4.0 / 29.0)
        temp = (self.L + 16.0) / 116.0
        y = wp_xyz.y * finv(temp)
        x = wp_xyz.x * finv(temp + self.a / 500.0)
        z = wp_xyz.z * finv(temp - self.b / 200.0)
        return XYZColor(x, y, z)

class XYYColor(object):
    """Represents a color in the CIE xyY color space."""

    def __init__(self, x, y, Y):
        self.x = x
        self.y = y
        self.Y = Y

    def to_xyz(self):
        x = self.Y * self.x / self.y
        z = self.Y * (1.0 - self.x - self.y) / self.y
        return XYZColor(x, self.Y, z)

class XYZColor(object):
    """Represents a color in the CIE XYZ color space."""

    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def to_lab(self, wp_xyz=None):
        """Converts the color to CIE LAB representation.

        Args:
            wp_xyz: XYZColor: Illuminant white point.

        Returns:
            LABColor object.
        """
        if wp_xyz is None:
            wp_xyz = ILLUMINANT_D65_10
        def f(t):
            if t > ((6.0 / 29.0) ** 3):
                return t ** (1.0 / 3.0)
            return ((t * 841.0) / 108.0) + (4.0 / 29.0)
        l = 116.0 * f(self.y / wp_xyz.y) - 16.0
        a = 500.0 * (f(self.x / wp_xyz.x) - f(self.y / wp_xyz.y))
        b = 200.0 * (f(self.y / wp_xyz.y) - f(self.z / wp_xyz.z))
        return LABColor(l, a, b)

    def to_srgb(self):
        rl =  3.2406 * self.x - 1.5372 * self.y - 0.4986 * self.z
        gl = -0.9689 * self.x + 1.8758 * self.y + 0.0415 * self.z
        bl =  0.0557 * self.x - 0.2040 * self.y + 1.0570 * self.z
        def linear_to_srgb(c):
            # Clamp to [0, 1]
            if c < 0.0:
                c = 0.0
            elif c > 1.0:
                c = 1.0
            if c <= 0.0031308:
                return 12.92 * c
            return 1.055 * (c ** (1.0 / 2.4)) - 0.055
        r, g, b = (linear_to_srgb(c) for c in (rl, gl, bl))
        return sRGBColor(r, g, b)

class sRGBColor(object):
    """Represents a color in the sRGB color space."""

    def __init__(self, r, g, b):
        self.r = r
        self.g = g
        self.b = b

    @classmethod
    def from_24b(cls, r256, g256, b256):
        """Creates a sRGBColor object from a triplet of values 0-255."""
        return cls(r256 / 255.0, g256 / 255.0, b256 / 255.0)

    @classmethod
    def from_str(cls, hex_str):
        """Creates a sRGBColor object from a string like "#123456"."""
        return cls.from_24b(int(hex_str[1:3], 16), int(hex_str[3:5], 16),
                            int(hex_str[5:7], 16))

    def __str__(self):
        # Skip the 0x and pad to 2 characters
        return "#" + "".join(("00" + hex(c)[2:])[-2:] for c in self.to_24b())

    def to_24b(self):
        def to_8b(c):
            c8b = int(round(c * 255.0))
            if c8b < 0:
                c8b = 0
            elif c8b > 255:
                c8b = 255
            return c8b
        return (to_8b(self.r), to_8b(self.g), to_8b(self.b))

    def to_xyz(self):
        def srgb_to_linear(c):
            if c <= 0.04045:
                return c / 12.92
            return ((c + 0.055) / 1.055) ** 2.4
        rl, gl, bl = (srgb_to_linear(c) for c in (self.r, self.g, self.b))
        x = 0.4124 * rl + 0.3576 * gl + 0.1805 * bl
        y = 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
        z = 0.0193 * rl + 0.1192 * gl + 0.9505 * bl
        return XYZColor(x, y, z)

# List of sRGB color objects indexed by terminal color code.
TERM256_RGB = [
        sRGBColor.from_24b(0x00, 0x00, 0x00),  # 0
        sRGBColor.from_24b(0x80, 0x00, 0x00),  # 1
        sRGBColor.from_24b(0x00, 0x80, 0x00),  # 2
        sRGBColor.from_24b(0x80, 0x80, 0x00),  # 3
        sRGBColor.from_24b(0x00, 0x00, 0x80),  # 4
        sRGBColor.from_24b(0x80, 0x00, 0x80),  # 5
        sRGBColor.from_24b(0x00, 0x80, 0x80),  # 6
        sRGBColor.from_24b(0xc0, 0xc0, 0xc0),  # 7
        sRGBColor.from_24b(0x80, 0x80, 0x80),  # 8
        sRGBColor.from_24b(0xff, 0x00, 0x00),  # 9
        sRGBColor.from_24b(0x00, 0xff, 0x00),  # 10
        sRGBColor.from_24b(0xff, 0xff, 0x00),  # 11
        sRGBColor.from_24b(0x00, 0x00, 0xff),  # 12
        sRGBColor.from_24b(0xff, 0x00, 0xff),  # 13
        sRGBColor.from_24b(0x00, 0xff, 0xff),  # 14
        sRGBColor.from_24b(0xff, 0xff, 0xff),  # 15
        sRGBColor.from_24b(0x00, 0x00, 0x00),  # 16: Grey0
        sRGBColor.from_24b(0x00, 0x00, 0x5f),  # 17: NavyBlue
        sRGBColor.from_24b(0x00, 0x00, 0x87),  # 18: DarkBlue
        sRGBColor.from_24b(0x00, 0x00, 0xaf),  # 19: Blue3
        sRGBColor.from_24b(0x00, 0x00, 0xd7),  # 20: Blue3
        sRGBColor.from_24b(0x00, 0x00, 0xff),  # 21: Blue1
        sRGBColor.from_24b(0x00, 0x5f, 0x00),  # 22: DarkGreen
        sRGBColor.from_24b(0x00, 0x5f, 0x5f),  # 23: DeepSkyBlue4
        sRGBColor.from_24b(0x00, 0x5f, 0x87),  # 24: DeepSkyBlue4
        sRGBColor.from_24b(0x00, 0x5f, 0xaf),  # 25: DeepSkyBlue4
        sRGBColor.from_24b(0x00, 0x5f, 0xd7),  # 26: DodgerBlue3
        sRGBColor.from_24b(0x00, 0x5f, 0xff),  # 27: DodgerBlue2
        sRGBColor.from_24b(0x00, 0x87, 0x00),  # 28: Green4
        sRGBColor.from_24b(0x00, 0x87, 0x5f),  # 29: SpringGreen4
        sRGBColor.from_24b(0x00, 0x87, 0x87),  # 30: Turquoise4
        sRGBColor.from_24b(0x00, 0x87, 0xaf),  # 31: DeepSkyBlue3
        sRGBColor.from_24b(0x00, 0x87, 0xd7),  # 32: DeepSkyBlue3
        sRGBColor.from_24b(0x00, 0x87, 0xff),  # 33: DodgerBlue1
        sRGBColor.from_24b(0x00, 0xaf, 0x00),  # 34: Green3
        sRGBColor.from_24b(0x00, 0xaf, 0x5f),  # 35: SpringGreen3
        sRGBColor.from_24b(0x00, 0xaf, 0x87),  # 36: DarkCyan
        sRGBColor.from_24b(0x00, 0xaf, 0xaf),  # 37: LightSeaGreen
        sRGBColor.from_24b(0x00, 0xaf, 0xd7),  # 38: DeepSkyBlue2
        sRGBColor.from_24b(0x00, 0xaf, 0xff),  # 39: DeepSkyBlue1
        sRGBColor.from_24b(0x00, 0xd7, 0x00),  # 40: Green3
        sRGBColor.from_24b(0x00, 0xd7, 0x5f),  # 41: SpringGreen3
        sRGBColor.from_24b(0x00, 0xd7, 0x87),  # 42: SpringGreen2
        sRGBColor.from_24b(0x00, 0xd7, 0xaf),  # 43: Cyan3
        sRGBColor.from_24b(0x00, 0xd7, 0xd7),  # 44: DarkTurquoise
        sRGBColor.from_24b(0x00, 0xd7, 0xff),  # 45: Turquoise2
        sRGBColor.from_24b(0x00, 0xff, 0x00),  # 46: Green1
        sRGBColor.from_24b(0x00, 0xff, 0x5f),  # 47: SpringGreen2
        sRGBColor.from_24b(0x00, 0xff, 0x87),  # 48: SpringGreen1
        sRGBColor.from_24b(0x00, 0xff, 0xaf),  # 49: MediumSpringGreen
        sRGBColor.from_24b(0x00, 0xff, 0xd7),  # 50: Cyan2
        sRGBColor.from_24b(0x00, 0xff, 0xff),  # 51: Cyan1
        sRGBColor.from_24b(0x5f, 0x00, 0x00),  # 52: DarkRed
        sRGBColor.from_24b(0x5f, 0x00, 0x5f),  # 53: DeepPink4
        sRGBColor.from_24b(0x5f, 0x00, 0x87),  # 54: Purple4
        sRGBColor.from_24b(0x5f, 0x00, 0xaf),  # 55: Purple4
        sRGBColor.from_24b(0x5f, 0x00, 0xd7),  # 56: Purple3
        sRGBColor.from_24b(0x5f, 0x00, 0xff),  # 57: BlueViolet
        sRGBColor.from_24b(0x5f, 0x5f, 0x00),  # 58: Orange4
        sRGBColor.from_24b(0x5f, 0x5f, 0x5f),  # 59: Grey37
        sRGBColor.from_24b(0x5f, 0x5f, 0x87),  # 60: MediumPurple4
        sRGBColor.from_24b(0x5f, 0x5f, 0xaf),  # 61: SlateBlue3
        sRGBColor.from_24b(0x5f, 0x5f, 0xd7),  # 62: SlateBlue3
        sRGBColor.from_24b(0x5f, 0x5f, 0xff),  # 63: RoyalBlue1
        sRGBColor.from_24b(0x5f, 0x87, 0x00),  # 64: Chartreuse4
        sRGBColor.from_24b(0x5f, 0x87, 0x5f),  # 65: DarkSeaGreen4
        sRGBColor.from_24b(0x5f, 0x87, 0x87),  # 66: PaleTurquoise4
        sRGBColor.from_24b(0x5f, 0x87, 0xaf),  # 67: SteelBlue
        sRGBColor.from_24b(0x5f, 0x87, 0xd7),  # 68: SteelBlue3
        sRGBColor.from_24b(0x5f, 0x87, 0xff),  # 69: CornflowerBlue
        sRGBColor.from_24b(0x5f, 0xaf, 0x00),  # 70: Chartreuse3
        sRGBColor.from_24b(0x5f, 0xaf, 0x5f),  # 71: DarkSeaGreen4
        sRGBColor.from_24b(0x5f, 0xaf, 0x87),  # 72: CadetBlue
        sRGBColor.from_24b(0x5f, 0xaf, 0xaf),  # 73: CadetBlue
        sRGBColor.from_24b(0x5f, 0xaf, 0xd7),  # 74: SkyBlue3
        sRGBColor.from_24b(0x5f, 0xaf, 0xff),  # 75: SteelBlue1
        sRGBColor.from_24b(0x5f, 0xd7, 0x00),  # 76: Chartreuse3
        sRGBColor.from_24b(0x5f, 0xd7, 0x5f),  # 77: PaleGreen3
        sRGBColor.from_24b(0x5f, 0xd7, 0x87),  # 78: SeaGreen3
        sRGBColor.from_24b(0x5f, 0xd7, 0xaf),  # 79: Aquamarine3
        sRGBColor.from_24b(0x5f, 0xd7, 0xd7),  # 80: MediumTurquoise
        sRGBColor.from_24b(0x5f, 0xd7, 0xff),  # 81: SteelBlue1
        sRGBColor.from_24b(0x5f, 0xff, 0x00),  # 82: Chartreuse2
        sRGBColor.from_24b(0x5f, 0xff, 0x5f),  # 83: SeaGreen2
        sRGBColor.from_24b(0x5f, 0xff, 0x87),  # 84: SeaGreen1
        sRGBColor.from_24b(0x5f, 0xff, 0xaf),  # 85: SeaGreen1
        sRGBColor.from_24b(0x5f, 0xff, 0xd7),  # 86: Aquamarine1
        sRGBColor.from_24b(0x5f, 0xff, 0xff),  # 87: DarkSlateGray2
        sRGBColor.from_24b(0x87, 0x00, 0x00),  # 88: DarkRed
        sRGBColor.from_24b(0x87, 0x00, 0x5f),  # 89: DeepPink4
        sRGBColor.from_24b(0x87, 0x00, 0x87),  # 90: DarkMagenta
        sRGBColor.from_24b(0x87, 0x00, 0xaf),  # 91: DarkMagenta
        sRGBColor.from_24b(0x87, 0x00, 0xd7),  # 92: DarkViolet
        sRGBColor.from_24b(0x87, 0x00, 0xff),  # 93: Purple
        sRGBColor.from_24b(0x87, 0x5f, 0x00),  # 94: Orange4
        sRGBColor.from_24b(0x87, 0x5f, 0x5f),  # 95: LightPink4
        sRGBColor.from_24b(0x87, 0x5f, 0x87),  # 96: Plum4
        sRGBColor.from_24b(0x87, 0x5f, 0xaf),  # 97: MediumPurple3
        sRGBColor.from_24b(0x87, 0x5f, 0xd7),  # 98: MediumPurple3
        sRGBColor.from_24b(0x87, 0x5f, 0xff),  # 99: SlateBlue1
        sRGBColor.from_24b(0x87, 0x87, 0x00),  # 100: Yellow4
        sRGBColor.from_24b(0x87, 0x87, 0x5f),  # 101: Wheat4
        sRGBColor.from_24b(0x87, 0x87, 0x87),  # 102: Grey53
        sRGBColor.from_24b(0x87, 0x87, 0xaf),  # 103: LightSlateGrey
        sRGBColor.from_24b(0x87, 0x87, 0xd7),  # 104: MediumPurple
        sRGBColor.from_24b(0x87, 0x87, 0xff),  # 105: LightSlateBlue
        sRGBColor.from_24b(0x87, 0xaf, 0x00),  # 106: Yellow4
        sRGBColor.from_24b(0x87, 0xaf, 0x5f),  # 107: DarkOliveGreen3
        sRGBColor.from_24b(0x87, 0xaf, 0x87),  # 108: DarkSeaGreen
        sRGBColor.from_24b(0x87, 0xaf, 0xaf),  # 109: LightSkyBlue3
        sRGBColor.from_24b(0x87, 0xaf, 0xd7),  # 110: LightSkyBlue3
        sRGBColor.from_24b(0x87, 0xaf, 0xff),  # 111: SkyBlue2
        sRGBColor.from_24b(0x87, 0xd7, 0x00),  # 112: Chartreuse2
        sRGBColor.from_24b(0x87, 0xd7, 0x5f),  # 113: DarkOliveGreen3
        sRGBColor.from_24b(0x87, 0xd7, 0x87),  # 114: PaleGreen3
        sRGBColor.from_24b(0x87, 0xd7, 0xaf),  # 115: DarkSeaGreen3
        sRGBColor.from_24b(0x87, 0xd7, 0xd7),  # 116: DarkSlateGray3
        sRGBColor.from_24b(0x87, 0xd7, 0xff),  # 117: SkyBlue1
        sRGBColor.from_24b(0x87, 0xff, 0x00),  # 118: Chartreuse1
        sRGBColor.from_24b(0x87, 0xff, 0x5f),  # 119: LightGreen
        sRGBColor.from_24b(0x87, 0xff, 0x87),  # 120: LightGreen
        sRGBColor.from_24b(0x87, 0xff, 0xaf),  # 121: PaleGreen1
        sRGBColor.from_24b(0x87, 0xff, 0xd7),  # 122: Aquamarine1
        sRGBColor.from_24b(0x87, 0xff, 0xff),  # 123: DarkSlateGray1
        sRGBColor.from_24b(0xaf, 0x00, 0x00),  # 124: Red3
        sRGBColor.from_24b(0xaf, 0x00, 0x5f),  # 125: DeepPink4
        sRGBColor.from_24b(0xaf, 0x00, 0x87),  # 126: MediumVioletRed
        sRGBColor.from_24b(0xaf, 0x00, 0xaf),  # 127: Magenta3
        sRGBColor.from_24b(0xaf, 0x00, 0xd7),  # 128: DarkViolet
        sRGBColor.from_24b(0xaf, 0x00, 0xff),  # 129: Purple
        sRGBColor.from_24b(0xaf, 0x5f, 0x00),  # 130: DarkOrange3
        sRGBColor.from_24b(0xaf, 0x5f, 0x5f),  # 131: IndianRed
        sRGBColor.from_24b(0xaf, 0x5f, 0x87),  # 132: HotPink3
        sRGBColor.from_24b(0xaf, 0x5f, 0xaf),  # 133: MediumOrchid3
        sRGBColor.from_24b(0xaf, 0x5f, 0xd7),  # 134: MediumOrchid
        sRGBColor.from_24b(0xaf, 0x5f, 0xff),  # 135: MediumPurple2
        sRGBColor.from_24b(0xaf, 0x87, 0x00),  # 136: DarkGoldenrod
        sRGBColor.from_24b(0xaf, 0x87, 0x5f),  # 137: LightSalmon3
        sRGBColor.from_24b(0xaf, 0x87, 0x87),  # 138: RosyBrown
        sRGBColor.from_24b(0xaf, 0x87, 0xaf),  # 139: Grey63
        sRGBColor.from_24b(0xaf, 0x87, 0xd7),  # 140: MediumPurple2
        sRGBColor.from_24b(0xaf, 0x87, 0xff),  # 141: MediumPurple1
        sRGBColor.from_24b(0xaf, 0xaf, 0x00),  # 142: Gold3
        sRGBColor.from_24b(0xaf, 0xaf, 0x5f),  # 143: DarkKhaki
        sRGBColor.from_24b(0xaf, 0xaf, 0x87),  # 144: NavajoWhite3
        sRGBColor.from_24b(0xaf, 0xaf, 0xaf),  # 145: Grey69
        sRGBColor.from_24b(0xaf, 0xaf, 0xd7),  # 146: LightSteelBlue3
        sRGBColor.from_24b(0xaf, 0xaf, 0xff),  # 147: LightSteelBlue
        sRGBColor.from_24b(0xaf, 0xd7, 0x00),  # 148: Yellow3
        sRGBColor.from_24b(0xaf, 0xd7, 0x5f),  # 149: DarkOliveGreen3
        sRGBColor.from_24b(0xaf, 0xd7, 0x87),  # 150: DarkSeaGreen3
        sRGBColor.from_24b(0xaf, 0xd7, 0xaf),  # 151: DarkSeaGreen2
        sRGBColor.from_24b(0xaf, 0xd7, 0xd7),  # 152: LightCyan3
        sRGBColor.from_24b(0xaf, 0xd7, 0xff),  # 153: LightSkyBlue1
        sRGBColor.from_24b(0xaf, 0xff, 0x00),  # 154: GreenYellow
        sRGBColor.from_24b(0xaf, 0xff, 0x5f),  # 155: DarkOliveGreen2
        sRGBColor.from_24b(0xaf, 0xff, 0x87),  # 156: PaleGreen1
        sRGBColor.from_24b(0xaf, 0xff, 0xaf),  # 157: DarkSeaGreen2
        sRGBColor.from_24b(0xaf, 0xff, 0xd7),  # 158: DarkSeaGreen1
        sRGBColor.from_24b(0xaf, 0xff, 0xff),  # 159: PaleTurquoise1
        sRGBColor.from_24b(0xd7, 0x00, 0x00),  # 160: Red3
        sRGBColor.from_24b(0xd7, 0x00, 0x5f),  # 161: DeepPink3
        sRGBColor.from_24b(0xd7, 0x00, 0x87),  # 162: DeepPink3
        sRGBColor.from_24b(0xd7, 0x00, 0xaf),  # 163: Magenta3
        sRGBColor.from_24b(0xd7, 0x00, 0xd7),  # 164: Magenta3
        sRGBColor.from_24b(0xd7, 0x00, 0xff),  # 165: Magenta2
        sRGBColor.from_24b(0xd7, 0x5f, 0x00),  # 166: DarkOrange3
        sRGBColor.from_24b(0xd7, 0x5f, 0x5f),  # 167: IndianRed
        sRGBColor.from_24b(0xd7, 0x5f, 0x87),  # 168: HotPink3
        sRGBColor.from_24b(0xd7, 0x5f, 0xaf),  # 169: HotPink2
        sRGBColor.from_24b(0xd7, 0x5f, 0xd7),  # 170: Orchid
        sRGBColor.from_24b(0xd7, 0x5f, 0xff),  # 171: MediumOrchid1
        sRGBColor.from_24b(0xd7, 0x87, 0x00),  # 172: Orange3
        sRGBColor.from_24b(0xd7, 0x87, 0x5f),  # 173: LightSalmon3
        sRGBColor.from_24b(0xd7, 0x87, 0x87),  # 174: LightPink3
        sRGBColor.from_24b(0xd7, 0x87, 0xaf),  # 175: Pink3
        sRGBColor.from_24b(0xd7, 0x87, 0xd7),  # 176: Plum3
        sRGBColor.from_24b(0xd7, 0x87, 0xff),  # 177: Violet
        sRGBColor.from_24b(0xd7, 0xaf, 0x00),  # 178: Gold3
        sRGBColor.from_24b(0xd7, 0xaf, 0x5f),  # 179: LightGoldenrod3
        sRGBColor.from_24b(0xd7, 0xaf, 0x87),  # 180: Tan
        sRGBColor.from_24b(0xd7, 0xaf, 0xaf),  # 181: MistyRose3
        sRGBColor.from_24b(0xd7, 0xaf, 0xd7),  # 182: Thistle3
        sRGBColor.from_24b(0xd7, 0xaf, 0xff),  # 183: Plum2
        sRGBColor.from_24b(0xd7, 0xd7, 0x00),  # 184: Yellow3
        sRGBColor.from_24b(0xd7, 0xd7, 0x5f),  # 185: Khaki3
        sRGBColor.from_24b(0xd7, 0xd7, 0x87),  # 186: LightGoldenrod2
        sRGBColor.from_24b(0xd7, 0xd7, 0xaf),  # 187: LightYellow3
        sRGBColor.from_24b(0xd7, 0xd7, 0xd7),  # 188: Grey84
        sRGBColor.from_24b(0xd7, 0xd7, 0xff),  # 189: LightSteelBlue1
        sRGBColor.from_24b(0xd7, 0xff, 0x00),  # 190: Yellow2
        sRGBColor.from_24b(0xd7, 0xff, 0x5f),  # 191: DarkOliveGreen1
        sRGBColor.from_24b(0xd7, 0xff, 0x87),  # 192: DarkOliveGreen1
        sRGBColor.from_24b(0xd7, 0xff, 0xaf),  # 193: DarkSeaGreen1
        sRGBColor.from_24b(0xd7, 0xff, 0xd7),  # 194: Honeydew2
        sRGBColor.from_24b(0xd7, 0xff, 0xff),  # 195: LightCyan1
        sRGBColor.from_24b(0xff, 0x00, 0x00),  # 196: Red1
        sRGBColor.from_24b(0xff, 0x00, 0x5f),  # 197: DeepPink2
        sRGBColor.from_24b(0xff, 0x00, 0x87),  # 198: DeepPink1
        sRGBColor.from_24b(0xff, 0x00, 0xaf),  # 199: DeepPink1
        sRGBColor.from_24b(0xff, 0x00, 0xd7),  # 200: Magenta2
        sRGBColor.from_24b(0xff, 0x00, 0xff),  # 201: Magenta1
        sRGBColor.from_24b(0xff, 0x5f, 0x00),  # 202: OrangeRed1
        sRGBColor.from_24b(0xff, 0x5f, 0x5f),  # 203: IndianRed1
        sRGBColor.from_24b(0xff, 0x5f, 0x87),  # 204: IndianRed1
        sRGBColor.from_24b(0xff, 0x5f, 0xaf),  # 205: HotPink
        sRGBColor.from_24b(0xff, 0x5f, 0xd7),  # 206: HotPink
        sRGBColor.from_24b(0xff, 0x5f, 0xff),  # 207: MediumOrchid1
        sRGBColor.from_24b(0xff, 0x87, 0x00),  # 208: DarkOrange
        sRGBColor.from_24b(0xff, 0x87, 0x5f),  # 209: Salmon1
        sRGBColor.from_24b(0xff, 0x87, 0x87),  # 210: LightCoral
        sRGBColor.from_24b(0xff, 0x87, 0xaf),  # 211: PaleVioletRed1
        sRGBColor.from_24b(0xff, 0x87, 0xd7),  # 212: Orchid2
        sRGBColor.from_24b(0xff, 0x87, 0xff),  # 213: Orchid1
        sRGBColor.from_24b(0xff, 0xaf, 0x00),  # 214: Orange1
        sRGBColor.from_24b(0xff, 0xaf, 0x5f),  # 215: SandyBrown
        sRGBColor.from_24b(0xff, 0xaf, 0x87),  # 216: LightSalmon1
        sRGBColor.from_24b(0xff, 0xaf, 0xaf),  # 217: LightPink1
        sRGBColor.from_24b(0xff, 0xaf, 0xd7),  # 218: Pink1
        sRGBColor.from_24b(0xff, 0xaf, 0xff),  # 219: Plum1
        sRGBColor.from_24b(0xff, 0xd7, 0x00),  # 220: Gold1
        sRGBColor.from_24b(0xff, 0xd7, 0x5f),  # 221: LightGoldenrod2
        sRGBColor.from_24b(0xff, 0xd7, 0x87),  # 222: LightGoldenrod2
        sRGBColor.from_24b(0xff, 0xd7, 0xaf),  # 223: NavajoWhite1
        sRGBColor.from_24b(0xff, 0xd7, 0xd7),  # 224: MistyRose1
        sRGBColor.from_24b(0xff, 0xd7, 0xff),  # 225: Thistle1
        sRGBColor.from_24b(0xff, 0xff, 0x00),  # 226: Yellow1
        sRGBColor.from_24b(0xff, 0xff, 0x5f),  # 227: LightGoldenrod1
        sRGBColor.from_24b(0xff, 0xff, 0x87),  # 228: Khaki1
        sRGBColor.from_24b(0xff, 0xff, 0xaf),  # 229: Wheat1
        sRGBColor.from_24b(0xff, 0xff, 0xd7),  # 230: Cornsilk1
        sRGBColor.from_24b(0xff, 0xff, 0xff),  # 231: Grey100
        sRGBColor.from_24b(0x08, 0x08, 0x08),  # 232: Grey3
        sRGBColor.from_24b(0x12, 0x12, 0x12),  # 233: Grey7
        sRGBColor.from_24b(0x1c, 0x1c, 0x1c),  # 234: Grey11
        sRGBColor.from_24b(0x26, 0x26, 0x26),  # 235: Grey15
        sRGBColor.from_24b(0x30, 0x30, 0x30),  # 236: Grey19
        sRGBColor.from_24b(0x3a, 0x3a, 0x3a),  # 237: Grey23
        sRGBColor.from_24b(0x44, 0x44, 0x44),  # 238: Grey27
        sRGBColor.from_24b(0x4e, 0x4e, 0x4e),  # 239: Grey30
        sRGBColor.from_24b(0x58, 0x58, 0x58),  # 240: Grey35
        sRGBColor.from_24b(0x62, 0x62, 0x62),  # 241: Grey39
        sRGBColor.from_24b(0x6c, 0x6c, 0x6c),  # 242: Grey42
        sRGBColor.from_24b(0x76, 0x76, 0x76),  # 243: Grey46
        sRGBColor.from_24b(0x80, 0x80, 0x80),  # 244: Grey50
        sRGBColor.from_24b(0x8a, 0x8a, 0x8a),  # 245: Grey54
        sRGBColor.from_24b(0x94, 0x94, 0x94),  # 246: Grey58
        sRGBColor.from_24b(0x9e, 0x9e, 0x9e),  # 247: Grey62
        sRGBColor.from_24b(0xa8, 0xa8, 0xa8),  # 248: Grey66
        sRGBColor.from_24b(0xb2, 0xb2, 0xb2),  # 249: Grey70
        sRGBColor.from_24b(0xbc, 0xbc, 0xbc),  # 250: Grey74
        sRGBColor.from_24b(0xc6, 0xc6, 0xc6),  # 251: Grey78
        sRGBColor.from_24b(0xd0, 0xd0, 0xd0),  # 252: Grey82
        sRGBColor.from_24b(0xda, 0xda, 0xda),  # 253: Grey85
        sRGBColor.from_24b(0xe4, 0xe4, 0xe4),  # 254: Grey89
        sRGBColor.from_24b(0xee, 0xee, 0xee),  # 255: Grey93
]

# Illuminants as XYZColor objects.
ILLUMINANT_D50_2 = XYYColor(0.34567, 0.35850, 1.0).to_xyz()
ILLUMINANT_D50_10 = XYYColor(0.34773, 0.35952, 1.0).to_xyz()
ILLUMINANT_D65_2 = XYYColor(0.31271, 0.32902, 1.0).to_xyz()
ILLUMINANT_D65_10 = XYYColor(0.31382, 0.33100, 1.0).to_xyz()

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
    return str(LABColor(l, a, b).to_xyz().to_srgb())

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
    return str(LABColor(l, a, b).to_xyz().to_srgb())

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

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
    def from_str(hex_str):
        """Creates a sRGBColor object from a string like "#123456"."""
        return cls.from_24b(int(hex_str[1:3], 16), int(hex_str[3:5], 16),
                            int(hex_str[5:7], 16))

    def __str__(self):
        def rah(c):
            c255 = int(round(c * 255.0))
            if c255 < 0:
                c255 = 0
            elif c255 > 255:
                c255 = 255
            # Skip the 0x and pad to 2 characters
            return ("00" + hex(c255)[2:])[-2:]
        return "#" + rah(self.r) + rah(self.g) + rah(self.b)

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

# Map of 4-bit terminal color codes to RGB color triplets.
TERM16_RGB = {
        0: (0x00, 0x00, 0x00),
        1: (0x80, 0x00, 0x00),
        2: (0x00, 0x80, 0x00),
        3: (0x80, 0x80, 0x00),
        4: (0x00, 0x00, 0x80),
        5: (0x80, 0x00, 0x80),
        6: (0x00, 0x80, 0x80),
        7: (0xc0, 0xc0, 0xc0),
        8: (0x80, 0x80, 0x80),
        9: (0xff, 0x00, 0x00),
        10: (0x00, 0xff, 0x00),
        11: (0xff, 0xff, 0x00),
        12: (0x00, 0x00, 0xff),
        13: (0xff, 0x00, 0xff),
        14: (0x00, 0xff, 0xff),
        15: (0xff, 0xff, 0xff),
}

# Map of 8-bit terminal color codes to RGB color triplets, not including the
# lower 16.
TERM256_RGB = {
        16: (0x00, 0x00, 0x00),  # Grey0
        17: (0x00, 0x00, 0x5f),  # NavyBlue
        18: (0x00, 0x00, 0x87),  # DarkBlue
        19: (0x00, 0x00, 0xaf),  # Blue3
        20: (0x00, 0x00, 0xd7),  # Blue3
        21: (0x00, 0x00, 0xff),  # Blue1
        22: (0x00, 0x5f, 0x00),  # DarkGreen
        23: (0x00, 0x5f, 0x5f),  # DeepSkyBlue4
        24: (0x00, 0x5f, 0x87),  # DeepSkyBlue4
        25: (0x00, 0x5f, 0xaf),  # DeepSkyBlue4
        26: (0x00, 0x5f, 0xd7),  # DodgerBlue3
        27: (0x00, 0x5f, 0xff),  # DodgerBlue2
        28: (0x00, 0x87, 0x00),  # Green4
        29: (0x00, 0x87, 0x5f),  # SpringGreen4
        30: (0x00, 0x87, 0x87),  # Turquoise4
        31: (0x00, 0x87, 0xaf),  # DeepSkyBlue3
        32: (0x00, 0x87, 0xd7),  # DeepSkyBlue3
        33: (0x00, 0x87, 0xff),  # DodgerBlue1
        34: (0x00, 0xaf, 0x00),  # Green3
        35: (0x00, 0xaf, 0x5f),  # SpringGreen3
        36: (0x00, 0xaf, 0x87),  # DarkCyan
        37: (0x00, 0xaf, 0xaf),  # LightSeaGreen
        38: (0x00, 0xaf, 0xd7),  # DeepSkyBlue2
        39: (0x00, 0xaf, 0xff),  # DeepSkyBlue1
        40: (0x00, 0xd7, 0x00),  # Green3
        41: (0x00, 0xd7, 0x5f),  # SpringGreen3
        42: (0x00, 0xd7, 0x87),  # SpringGreen2
        43: (0x00, 0xd7, 0xaf),  # Cyan3
        44: (0x00, 0xd7, 0xd7),  # DarkTurquoise
        45: (0x00, 0xd7, 0xff),  # Turquoise2
        46: (0x00, 0xff, 0x00),  # Green1
        47: (0x00, 0xff, 0x5f),  # SpringGreen2
        48: (0x00, 0xff, 0x87),  # SpringGreen1
        49: (0x00, 0xff, 0xaf),  # MediumSpringGreen
        50: (0x00, 0xff, 0xd7),  # Cyan2
        51: (0x00, 0xff, 0xff),  # Cyan1
        52: (0x5f, 0x00, 0x00),  # DarkRed
        53: (0x5f, 0x00, 0x5f),  # DeepPink4
        54: (0x5f, 0x00, 0x87),  # Purple4
        55: (0x5f, 0x00, 0xaf),  # Purple4
        56: (0x5f, 0x00, 0xd7),  # Purple3
        57: (0x5f, 0x00, 0xff),  # BlueViolet
        58: (0x5f, 0x5f, 0x00),  # Orange4
        59: (0x5f, 0x5f, 0x5f),  # Grey37
        60: (0x5f, 0x5f, 0x87),  # MediumPurple4
        61: (0x5f, 0x5f, 0xaf),  # SlateBlue3
        62: (0x5f, 0x5f, 0xd7),  # SlateBlue3
        63: (0x5f, 0x5f, 0xff),  # RoyalBlue1
        64: (0x5f, 0x87, 0x00),  # Chartreuse4
        65: (0x5f, 0x87, 0x5f),  # DarkSeaGreen4
        66: (0x5f, 0x87, 0x87),  # PaleTurquoise4
        67: (0x5f, 0x87, 0xaf),  # SteelBlue
        68: (0x5f, 0x87, 0xd7),  # SteelBlue3
        69: (0x5f, 0x87, 0xff),  # CornflowerBlue
        70: (0x5f, 0xaf, 0x00),  # Chartreuse3
        71: (0x5f, 0xaf, 0x5f),  # DarkSeaGreen4
        72: (0x5f, 0xaf, 0x87),  # CadetBlue
        73: (0x5f, 0xaf, 0xaf),  # CadetBlue
        74: (0x5f, 0xaf, 0xd7),  # SkyBlue3
        75: (0x5f, 0xaf, 0xff),  # SteelBlue1
        76: (0x5f, 0xd7, 0x00),  # Chartreuse3
        77: (0x5f, 0xd7, 0x5f),  # PaleGreen3
        78: (0x5f, 0xd7, 0x87),  # SeaGreen3
        79: (0x5f, 0xd7, 0xaf),  # Aquamarine3
        80: (0x5f, 0xd7, 0xd7),  # MediumTurquoise
        81: (0x5f, 0xd7, 0xff),  # SteelBlue1
        82: (0x5f, 0xff, 0x00),  # Chartreuse2
        83: (0x5f, 0xff, 0x5f),  # SeaGreen2
        84: (0x5f, 0xff, 0x87),  # SeaGreen1
        85: (0x5f, 0xff, 0xaf),  # SeaGreen1
        86: (0x5f, 0xff, 0xd7),  # Aquamarine1
        87: (0x5f, 0xff, 0xff),  # DarkSlateGray2
        88: (0x87, 0x00, 0x00),  # DarkRed
        89: (0x87, 0x00, 0x5f),  # DeepPink4
        90: (0x87, 0x00, 0x87),  # DarkMagenta
        91: (0x87, 0x00, 0xaf),  # DarkMagenta
        92: (0x87, 0x00, 0xd7),  # DarkViolet
        93: (0x87, 0x00, 0xff),  # Purple
        94: (0x87, 0x5f, 0x00),  # Orange4
        95: (0x87, 0x5f, 0x5f),  # LightPink4
        96: (0x87, 0x5f, 0x87),  # Plum4
        97: (0x87, 0x5f, 0xaf),  # MediumPurple3
        98: (0x87, 0x5f, 0xd7),  # MediumPurple3
        99: (0x87, 0x5f, 0xff),  # SlateBlue1
        100: (0x87, 0x87, 0x00),  # Yellow4
        101: (0x87, 0x87, 0x5f),  # Wheat4
        102: (0x87, 0x87, 0x87),  # Grey53
        103: (0x87, 0x87, 0xaf),  # LightSlateGrey
        104: (0x87, 0x87, 0xd7),  # MediumPurple
        105: (0x87, 0x87, 0xff),  # LightSlateBlue
        106: (0x87, 0xaf, 0x00),  # Yellow4
        107: (0x87, 0xaf, 0x5f),  # DarkOliveGreen3
        108: (0x87, 0xaf, 0x87),  # DarkSeaGreen
        109: (0x87, 0xaf, 0xaf),  # LightSkyBlue3
        110: (0x87, 0xaf, 0xd7),  # LightSkyBlue3
        111: (0x87, 0xaf, 0xff),  # SkyBlue2
        112: (0x87, 0xd7, 0x00),  # Chartreuse2
        113: (0x87, 0xd7, 0x5f),  # DarkOliveGreen3
        114: (0x87, 0xd7, 0x87),  # PaleGreen3
        115: (0x87, 0xd7, 0xaf),  # DarkSeaGreen3
        116: (0x87, 0xd7, 0xd7),  # DarkSlateGray3
        117: (0x87, 0xd7, 0xff),  # SkyBlue1
        118: (0x87, 0xff, 0x00),  # Chartreuse1
        119: (0x87, 0xff, 0x5f),  # LightGreen
        120: (0x87, 0xff, 0x87),  # LightGreen
        121: (0x87, 0xff, 0xaf),  # PaleGreen1
        122: (0x87, 0xff, 0xd7),  # Aquamarine1
        123: (0x87, 0xff, 0xff),  # DarkSlateGray1
        124: (0xaf, 0x00, 0x00),  # Red3
        125: (0xaf, 0x00, 0x5f),  # DeepPink4
        126: (0xaf, 0x00, 0x87),  # MediumVioletRed
        127: (0xaf, 0x00, 0xaf),  # Magenta3
        128: (0xaf, 0x00, 0xd7),  # DarkViolet
        129: (0xaf, 0x00, 0xff),  # Purple
        130: (0xaf, 0x5f, 0x00),  # DarkOrange3
        131: (0xaf, 0x5f, 0x5f),  # IndianRed
        132: (0xaf, 0x5f, 0x87),  # HotPink3
        133: (0xaf, 0x5f, 0xaf),  # MediumOrchid3
        134: (0xaf, 0x5f, 0xd7),  # MediumOrchid
        135: (0xaf, 0x5f, 0xff),  # MediumPurple2
        136: (0xaf, 0x87, 0x00),  # DarkGoldenrod
        137: (0xaf, 0x87, 0x5f),  # LightSalmon3
        138: (0xaf, 0x87, 0x87),  # RosyBrown
        139: (0xaf, 0x87, 0xaf),  # Grey63
        140: (0xaf, 0x87, 0xd7),  # MediumPurple2
        141: (0xaf, 0x87, 0xff),  # MediumPurple1
        142: (0xaf, 0xaf, 0x00),  # Gold3
        143: (0xaf, 0xaf, 0x5f),  # DarkKhaki
        144: (0xaf, 0xaf, 0x87),  # NavajoWhite3
        145: (0xaf, 0xaf, 0xaf),  # Grey69
        146: (0xaf, 0xaf, 0xd7),  # LightSteelBlue3
        147: (0xaf, 0xaf, 0xff),  # LightSteelBlue
        148: (0xaf, 0xd7, 0x00),  # Yellow3
        149: (0xaf, 0xd7, 0x5f),  # DarkOliveGreen3
        150: (0xaf, 0xd7, 0x87),  # DarkSeaGreen3
        151: (0xaf, 0xd7, 0xaf),  # DarkSeaGreen2
        152: (0xaf, 0xd7, 0xd7),  # LightCyan3
        153: (0xaf, 0xd7, 0xff),  # LightSkyBlue1
        154: (0xaf, 0xff, 0x00),  # GreenYellow
        155: (0xaf, 0xff, 0x5f),  # DarkOliveGreen2
        156: (0xaf, 0xff, 0x87),  # PaleGreen1
        157: (0xaf, 0xff, 0xaf),  # DarkSeaGreen2
        158: (0xaf, 0xff, 0xd7),  # DarkSeaGreen1
        159: (0xaf, 0xff, 0xff),  # PaleTurquoise1
        160: (0xd7, 0x00, 0x00),  # Red3
        161: (0xd7, 0x00, 0x5f),  # DeepPink3
        162: (0xd7, 0x00, 0x87),  # DeepPink3
        163: (0xd7, 0x00, 0xaf),  # Magenta3
        164: (0xd7, 0x00, 0xd7),  # Magenta3
        165: (0xd7, 0x00, 0xff),  # Magenta2
        166: (0xd7, 0x5f, 0x00),  # DarkOrange3
        167: (0xd7, 0x5f, 0x5f),  # IndianRed
        168: (0xd7, 0x5f, 0x87),  # HotPink3
        169: (0xd7, 0x5f, 0xaf),  # HotPink2
        170: (0xd7, 0x5f, 0xd7),  # Orchid
        171: (0xd7, 0x5f, 0xff),  # MediumOrchid1
        172: (0xd7, 0x87, 0x00),  # Orange3
        173: (0xd7, 0x87, 0x5f),  # LightSalmon3
        174: (0xd7, 0x87, 0x87),  # LightPink3
        175: (0xd7, 0x87, 0xaf),  # Pink3
        176: (0xd7, 0x87, 0xd7),  # Plum3
        177: (0xd7, 0x87, 0xff),  # Violet
        178: (0xd7, 0xaf, 0x00),  # Gold3
        179: (0xd7, 0xaf, 0x5f),  # LightGoldenrod3
        180: (0xd7, 0xaf, 0x87),  # Tan
        181: (0xd7, 0xaf, 0xaf),  # MistyRose3
        182: (0xd7, 0xaf, 0xd7),  # Thistle3
        183: (0xd7, 0xaf, 0xff),  # Plum2
        184: (0xd7, 0xd7, 0x00),  # Yellow3
        185: (0xd7, 0xd7, 0x5f),  # Khaki3
        186: (0xd7, 0xd7, 0x87),  # LightGoldenrod2
        187: (0xd7, 0xd7, 0xaf),  # LightYellow3
        188: (0xd7, 0xd7, 0xd7),  # Grey84
        189: (0xd7, 0xd7, 0xff),  # LightSteelBlue1
        190: (0xd7, 0xff, 0x00),  # Yellow2
        191: (0xd7, 0xff, 0x5f),  # DarkOliveGreen1
        192: (0xd7, 0xff, 0x87),  # DarkOliveGreen1
        193: (0xd7, 0xff, 0xaf),  # DarkSeaGreen1
        194: (0xd7, 0xff, 0xd7),  # Honeydew2
        195: (0xd7, 0xff, 0xff),  # LightCyan1
        196: (0xff, 0x00, 0x00),  # Red1
        197: (0xff, 0x00, 0x5f),  # DeepPink2
        198: (0xff, 0x00, 0x87),  # DeepPink1
        199: (0xff, 0x00, 0xaf),  # DeepPink1
        200: (0xff, 0x00, 0xd7),  # Magenta2
        201: (0xff, 0x00, 0xff),  # Magenta1
        202: (0xff, 0x5f, 0x00),  # OrangeRed1
        203: (0xff, 0x5f, 0x5f),  # IndianRed1
        204: (0xff, 0x5f, 0x87),  # IndianRed1
        205: (0xff, 0x5f, 0xaf),  # HotPink
        206: (0xff, 0x5f, 0xd7),  # HotPink
        207: (0xff, 0x5f, 0xff),  # MediumOrchid1
        208: (0xff, 0x87, 0x00),  # DarkOrange
        209: (0xff, 0x87, 0x5f),  # Salmon1
        210: (0xff, 0x87, 0x87),  # LightCoral
        211: (0xff, 0x87, 0xaf),  # PaleVioletRed1
        212: (0xff, 0x87, 0xd7),  # Orchid2
        213: (0xff, 0x87, 0xff),  # Orchid1
        214: (0xff, 0xaf, 0x00),  # Orange1
        215: (0xff, 0xaf, 0x5f),  # SandyBrown
        216: (0xff, 0xaf, 0x87),  # LightSalmon1
        217: (0xff, 0xaf, 0xaf),  # LightPink1
        218: (0xff, 0xaf, 0xd7),  # Pink1
        219: (0xff, 0xaf, 0xff),  # Plum1
        220: (0xff, 0xd7, 0x00),  # Gold1
        221: (0xff, 0xd7, 0x5f),  # LightGoldenrod2
        222: (0xff, 0xd7, 0x87),  # LightGoldenrod2
        223: (0xff, 0xd7, 0xaf),  # NavajoWhite1
        224: (0xff, 0xd7, 0xd7),  # MistyRose1
        225: (0xff, 0xd7, 0xff),  # Thistle1
        226: (0xff, 0xff, 0x00),  # Yellow1
        227: (0xff, 0xff, 0x5f),  # LightGoldenrod1
        228: (0xff, 0xff, 0x87),  # Khaki1
        229: (0xff, 0xff, 0xaf),  # Wheat1
        230: (0xff, 0xff, 0xd7),  # Cornsilk1
        231: (0xff, 0xff, 0xff),  # Grey100
        232: (0x08, 0x08, 0x08),  # Grey3
        233: (0x12, 0x12, 0x12),  # Grey7
        234: (0x1c, 0x1c, 0x1c),  # Grey11
        235: (0x26, 0x26, 0x26),  # Grey15
        236: (0x30, 0x30, 0x30),  # Grey19
        237: (0x3a, 0x3a, 0x3a),  # Grey23
        238: (0x44, 0x44, 0x44),  # Grey27
        239: (0x4e, 0x4e, 0x4e),  # Grey30
        240: (0x58, 0x58, 0x58),  # Grey35
        241: (0x62, 0x62, 0x62),  # Grey39
        242: (0x6c, 0x6c, 0x6c),  # Grey42
        243: (0x76, 0x76, 0x76),  # Grey46
        244: (0x80, 0x80, 0x80),  # Grey50
        245: (0x8a, 0x8a, 0x8a),  # Grey54
        246: (0x94, 0x94, 0x94),  # Grey58
        247: (0x9e, 0x9e, 0x9e),  # Grey62
        248: (0xa8, 0xa8, 0xa8),  # Grey66
        249: (0xb2, 0xb2, 0xb2),  # Grey70
        250: (0xbc, 0xbc, 0xbc),  # Grey74
        251: (0xc6, 0xc6, 0xc6),  # Grey78
        252: (0xd0, 0xd0, 0xd0),  # Grey82
        253: (0xda, 0xda, 0xda),  # Grey85
        254: (0xe4, 0xe4, 0xe4),  # Grey89
        255: (0xee, 0xee, 0xee),  # Grey93
}

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

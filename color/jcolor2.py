#!/usr/bin/env python3

import argparse
import math

###############################################################################
# Color models
###############################################################################

def srgb_from_linear(c: float) -> float:
    if c < 0.0031308:
        return 12.92 * c
    return 1.055 * (c ** (1.0 / 2.4)) - 0.055

def linear_from_srgb(c: float) -> float:
    if c < 0.04045:
        return c / 12.92
    return ((c + 0.055) / 1.055) ** 2.4

class RGBColor(object):
    """Represents a color in the sRGB color space."""
    def __init__(self, r: float, g: float, b: float):
        self.r = r
        self.g = g
        self.b = b

    @classmethod
    def from_8b(cls, r256: int, g256: int, b256: int) -> RGBColor:
        return cls(r256 / 255.0, g256 / 255.0, b256 / 255.0)

    def to_8b(self) -> tuple[int, int, int]:
        cl = self.clamped()
        b8 = lambda c: int(round(c * 255.0))
        return (b8(cl.r), b8(cl.g), b8(cl.b))

    @classmethod
    def from_str(cls, s: str) -> RGBColor:
        """Creates an RGBColor object from a string like "#123456"."""
        return cls.from_8b(int(s[1:3], 16), int(s[3:5], 16), int(s[5:7], 16))

    def __str__(self) -> str:
        # Skip the 0x and pad to 2 characters
        return "#" + "".join(("00" + hex(c)[2:])[-2:]
                             for c in self.clamped().to_8b())

    def to_oklab(self) -> OklabColor:
        rl, gl, bl = (linear_from_srgb(c) for c in (self.r, self.g, self.b))
        l = 0.4122214708 * rl + 0.5363325363 * gl + 0.0514459929 * bl
        m = 0.2119034982 * rl + 0.6806995451 * gl + 0.1073969566 * bl
        s = 0.0883024619 * rl + 0.2817188376 * gl + 0.6299787005 * bl
        l_ = l ** (1.0 / 3.0)
        m_ = m ** (1.0 / 3.0)
        s_ = s ** (1.0 / 3.0)
        return OklabColor(
                0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
                1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
                0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
        )

    def in_gamut(self) -> bool:
        return (0.0 <= self.r <= 1.0 and 0.0 <= self.g <= 1.0 and 0.0 <= self.b <= 1.0)

    def clamped(self) -> RGBColor:
        return RGBColor(
                max(0.0, min(1.0, self.r)),
                max(0.0, min(1.0, self.g)),
                max(0.0, min(1.0, self.b)),
        )

def rgb(val: int) -> RGBColor:
    """Returns an sRGB color given its 24-bit RGB value."""
    return RGBColor.from_8b((val >> 16) & 0xff, (val >> 8) & 0xff, val & 0xff)

def contrast(fg: RGBColor, bg: RGBColor) -> float:
    """Returns the WCAG 2 contrast ratio between two sRGB colors."""
    # https://www.w3.org/WAI/GL/wiki/Contrast_ratio
    # https://www.w3.org/WAI/GL/wiki/Relative_luminance
    def luminance(c: RGBColor) -> float:
        rl, gl, bl = (linear_from_srgb(x) for x in (c.r, c.g, c.b))
        return 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
    ratio = (luminance(fg) + 0.05) / (luminance(bg) + 0.05)
    if ratio < 1:
        ratio = 1 / ratio
    return ratio

class OklabColor(object):
    """Represents a color in the Oklab color space. See
    https://bottosson.github.io/posts/oklab/."""
    def __init__(self, L: float, a: float, b: float):
        self.L = L
        self.a = a
        self.b = b

    def to_rgb(self) -> RGBColor:
        l_ = self.L + 0.3963377774 * self.a + 0.2158037573 * self.b
        m_ = self.L - 0.1055613458 * self.a - 0.0638541728 * self.b
        s_ = self.L - 0.0894841775 * self.a - 1.2914855480 * self.b
        l = l_ * l_ * l_
        m = m_ * m_ * m_
        s = s_ * s_ * s_
        rl = +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
        gl = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
        bl = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
        return RGBColor(srgb_from_linear(rl), srgb_from_linear(gl),
                         srgb_from_linear(bl))

def perc_distance(c1: OklabColor, c2: OklabColor) -> float:
    """Returns the perceptual distance between two Oklab colors."""
    dL = c1.L - c2.L
    da = c1.a - c2.a
    db = c1.b - c2.b
    return math.sqrt(dL*dL + da*da + db*db)

class OklchColor(object):
    """Represents a color in the Oklch color space."""
    def __init__(self, L: float, C: float, h: float):
        self.L = L
        self.C = C
        self.h = h

    def to_rgb(self) -> RGBColor:
        return self.to_oklab().to_rgb()

    def to_oklab(self) -> OklabColor:
        h_rad = self.h * math.pi / 180.0
        a = self.C * math.cos(h_rad)
        b = self.C * math.sin(h_rad)
        return OklabColor(self.L, a, b)

###############################################################################
# Color systems
###############################################################################

# List of terminal colors, indexed by color code.
term256_rgb = [
        rgb(0x000000),  # 0
        rgb(0x800000),  # 1
        rgb(0x008000),  # 2
        rgb(0x808000),  # 3
        rgb(0x000080),  # 4
        rgb(0x800080),  # 5
        rgb(0x008080),  # 6
        rgb(0xc0c0c0),  # 7
        rgb(0x808080),  # 8
        rgb(0xff0000),  # 9
        rgb(0x00ff00),  # 10
        rgb(0xffff00),  # 11
        rgb(0x0000ff),  # 12
        rgb(0xff00ff),  # 13
        rgb(0x00ffff),  # 14
        rgb(0xffffff),  # 15
        rgb(0x000000),  # 16: Grey0
        rgb(0x00005f),  # 17: NavyBlue
        rgb(0x000087),  # 18: DarkBlue
        rgb(0x0000af),  # 19: Blue3
        rgb(0x0000d7),  # 20: Blue3
        rgb(0x0000ff),  # 21: Blue1
        rgb(0x005f00),  # 22: DarkGreen
        rgb(0x005f5f),  # 23: DeepSkyBlue4
        rgb(0x005f87),  # 24: DeepSkyBlue4
        rgb(0x005faf),  # 25: DeepSkyBlue4
        rgb(0x005fd7),  # 26: DodgerBlue3
        rgb(0x005fff),  # 27: DodgerBlue2
        rgb(0x008700),  # 28: Green4
        rgb(0x00875f),  # 29: SpringGreen4
        rgb(0x008787),  # 30: Turquoise4
        rgb(0x0087af),  # 31: DeepSkyBlue3
        rgb(0x0087d7),  # 32: DeepSkyBlue3
        rgb(0x0087ff),  # 33: DodgerBlue1
        rgb(0x00af00),  # 34: Green3
        rgb(0x00af5f),  # 35: SpringGreen3
        rgb(0x00af87),  # 36: DarkCyan
        rgb(0x00afaf),  # 37: LightSeaGreen
        rgb(0x00afd7),  # 38: DeepSkyBlue2
        rgb(0x00afff),  # 39: DeepSkyBlue1
        rgb(0x00d700),  # 40: Green3
        rgb(0x00d75f),  # 41: SpringGreen3
        rgb(0x00d787),  # 42: SpringGreen2
        rgb(0x00d7af),  # 43: Cyan3
        rgb(0x00d7d7),  # 44: DarkTurquoise
        rgb(0x00d7ff),  # 45: Turquoise2
        rgb(0x00ff00),  # 46: Green1
        rgb(0x00ff5f),  # 47: SpringGreen2
        rgb(0x00ff87),  # 48: SpringGreen1
        rgb(0x00ffaf),  # 49: MediumSpringGreen
        rgb(0x00ffd7),  # 50: Cyan2
        rgb(0x00ffff),  # 51: Cyan1
        rgb(0x5f0000),  # 52: DarkRed
        rgb(0x5f005f),  # 53: DeepPink4
        rgb(0x5f0087),  # 54: Purple4
        rgb(0x5f00af),  # 55: Purple4
        rgb(0x5f00d7),  # 56: Purple3
        rgb(0x5f00ff),  # 57: BlueViolet
        rgb(0x5f5f00),  # 58: Orange4
        rgb(0x5f5f5f),  # 59: Grey37
        rgb(0x5f5f87),  # 60: MediumPurple4
        rgb(0x5f5faf),  # 61: SlateBlue3
        rgb(0x5f5fd7),  # 62: SlateBlue3
        rgb(0x5f5fff),  # 63: RoyalBlue1
        rgb(0x5f8700),  # 64: Chartreuse4
        rgb(0x5f875f),  # 65: DarkSeaGreen4
        rgb(0x5f8787),  # 66: PaleTurquoise4
        rgb(0x5f87af),  # 67: SteelBlue
        rgb(0x5f87d7),  # 68: SteelBlue3
        rgb(0x5f87ff),  # 69: CornflowerBlue
        rgb(0x5faf00),  # 70: Chartreuse3
        rgb(0x5faf5f),  # 71: DarkSeaGreen4
        rgb(0x5faf87),  # 72: CadetBlue
        rgb(0x5fafaf),  # 73: CadetBlue
        rgb(0x5fafd7),  # 74: SkyBlue3
        rgb(0x5fafff),  # 75: SteelBlue1
        rgb(0x5fd700),  # 76: Chartreuse3
        rgb(0x5fd75f),  # 77: PaleGreen3
        rgb(0x5fd787),  # 78: SeaGreen3
        rgb(0x5fd7af),  # 79: Aquamarine3
        rgb(0x5fd7d7),  # 80: MediumTurquoise
        rgb(0x5fd7ff),  # 81: SteelBlue1
        rgb(0x5fff00),  # 82: Chartreuse2
        rgb(0x5fff5f),  # 83: SeaGreen2
        rgb(0x5fff87),  # 84: SeaGreen1
        rgb(0x5fffaf),  # 85: SeaGreen1
        rgb(0x5fffd7),  # 86: Aquamarine1
        rgb(0x5fffff),  # 87: DarkSlateGray2
        rgb(0x870000),  # 88: DarkRed
        rgb(0x87005f),  # 89: DeepPink4
        rgb(0x870087),  # 90: DarkMagenta
        rgb(0x8700af),  # 91: DarkMagenta
        rgb(0x8700d7),  # 92: DarkViolet
        rgb(0x8700ff),  # 93: Purple
        rgb(0x875f00),  # 94: Orange4
        rgb(0x875f5f),  # 95: LightPink4
        rgb(0x875f87),  # 96: Plum4
        rgb(0x875faf),  # 97: MediumPurple3
        rgb(0x875fd7),  # 98: MediumPurple3
        rgb(0x875fff),  # 99: SlateBlue1
        rgb(0x878700),  # 100: Yellow4
        rgb(0x87875f),  # 101: Wheat4
        rgb(0x878787),  # 102: Grey53
        rgb(0x8787af),  # 103: LightSlateGrey
        rgb(0x8787d7),  # 104: MediumPurple
        rgb(0x8787ff),  # 105: LightSlateBlue
        rgb(0x87af00),  # 106: Yellow4
        rgb(0x87af5f),  # 107: DarkOliveGreen3
        rgb(0x87af87),  # 108: DarkSeaGreen
        rgb(0x87afaf),  # 109: LightSkyBlue3
        rgb(0x87afd7),  # 110: LightSkyBlue3
        rgb(0x87afff),  # 111: SkyBlue2
        rgb(0x87d700),  # 112: Chartreuse2
        rgb(0x87d75f),  # 113: DarkOliveGreen3
        rgb(0x87d787),  # 114: PaleGreen3
        rgb(0x87d7af),  # 115: DarkSeaGreen3
        rgb(0x87d7d7),  # 116: DarkSlateGray3
        rgb(0x87d7ff),  # 117: SkyBlue1
        rgb(0x87ff00),  # 118: Chartreuse1
        rgb(0x87ff5f),  # 119: LightGreen
        rgb(0x87ff87),  # 120: LightGreen
        rgb(0x87ffaf),  # 121: PaleGreen1
        rgb(0x87ffd7),  # 122: Aquamarine1
        rgb(0x87ffff),  # 123: DarkSlateGray1
        rgb(0xaf0000),  # 124: Red3
        rgb(0xaf005f),  # 125: DeepPink4
        rgb(0xaf0087),  # 126: MediumVioletRed
        rgb(0xaf00af),  # 127: Magenta3
        rgb(0xaf00d7),  # 128: DarkViolet
        rgb(0xaf00ff),  # 129: Purple
        rgb(0xaf5f00),  # 130: DarkOrange3
        rgb(0xaf5f5f),  # 131: IndianRed
        rgb(0xaf5f87),  # 132: HotPink3
        rgb(0xaf5faf),  # 133: MediumOrchid3
        rgb(0xaf5fd7),  # 134: MediumOrchid
        rgb(0xaf5fff),  # 135: MediumPurple2
        rgb(0xaf8700),  # 136: DarkGoldenrod
        rgb(0xaf875f),  # 137: LightSalmon3
        rgb(0xaf8787),  # 138: RosyBrown
        rgb(0xaf87af),  # 139: Grey63
        rgb(0xaf87d7),  # 140: MediumPurple2
        rgb(0xaf87ff),  # 141: MediumPurple1
        rgb(0xafaf00),  # 142: Gold3
        rgb(0xafaf5f),  # 143: DarkKhaki
        rgb(0xafaf87),  # 144: NavajoWhite3
        rgb(0xafafaf),  # 145: Grey69
        rgb(0xafafd7),  # 146: LightSteelBlue3
        rgb(0xafafff),  # 147: LightSteelBlue
        rgb(0xafd700),  # 148: Yellow3
        rgb(0xafd75f),  # 149: DarkOliveGreen3
        rgb(0xafd787),  # 150: DarkSeaGreen3
        rgb(0xafd7af),  # 151: DarkSeaGreen2
        rgb(0xafd7d7),  # 152: LightCyan3
        rgb(0xafd7ff),  # 153: LightSkyBlue1
        rgb(0xafff00),  # 154: GreenYellow
        rgb(0xafff5f),  # 155: DarkOliveGreen2
        rgb(0xafff87),  # 156: PaleGreen1
        rgb(0xafffaf),  # 157: DarkSeaGreen2
        rgb(0xafffd7),  # 158: DarkSeaGreen1
        rgb(0xafffff),  # 159: PaleTurquoise1
        rgb(0xd70000),  # 160: Red3
        rgb(0xd7005f),  # 161: DeepPink3
        rgb(0xd70087),  # 162: DeepPink3
        rgb(0xd700af),  # 163: Magenta3
        rgb(0xd700d7),  # 164: Magenta3
        rgb(0xd700ff),  # 165: Magenta2
        rgb(0xd75f00),  # 166: DarkOrange3
        rgb(0xd75f5f),  # 167: IndianRed
        rgb(0xd75f87),  # 168: HotPink3
        rgb(0xd75faf),  # 169: HotPink2
        rgb(0xd75fd7),  # 170: Orchid
        rgb(0xd75fff),  # 171: MediumOrchid1
        rgb(0xd78700),  # 172: Orange3
        rgb(0xd7875f),  # 173: LightSalmon3
        rgb(0xd78787),  # 174: LightPink3
        rgb(0xd787af),  # 175: Pink3
        rgb(0xd787d7),  # 176: Plum3
        rgb(0xd787ff),  # 177: Violet
        rgb(0xd7af00),  # 178: Gold3
        rgb(0xd7af5f),  # 179: LightGoldenrod3
        rgb(0xd7af87),  # 180: Tan
        rgb(0xd7afaf),  # 181: MistyRose3
        rgb(0xd7afd7),  # 182: Thistle3
        rgb(0xd7afff),  # 183: Plum2
        rgb(0xd7d700),  # 184: Yellow3
        rgb(0xd7d75f),  # 185: Khaki3
        rgb(0xd7d787),  # 186: LightGoldenrod2
        rgb(0xd7d7af),  # 187: LightYellow3
        rgb(0xd7d7d7),  # 188: Grey84
        rgb(0xd7d7ff),  # 189: LightSteelBlue1
        rgb(0xd7ff00),  # 190: Yellow2
        rgb(0xd7ff5f),  # 191: DarkOliveGreen1
        rgb(0xd7ff87),  # 192: DarkOliveGreen1
        rgb(0xd7ffaf),  # 193: DarkSeaGreen1
        rgb(0xd7ffd7),  # 194: Honeydew2
        rgb(0xd7ffff),  # 195: LightCyan1
        rgb(0xff0000),  # 196: Red1
        rgb(0xff005f),  # 197: DeepPink2
        rgb(0xff0087),  # 198: DeepPink1
        rgb(0xff00af),  # 199: DeepPink1
        rgb(0xff00d7),  # 200: Magenta2
        rgb(0xff00ff),  # 201: Magenta1
        rgb(0xff5f00),  # 202: OrangeRed1
        rgb(0xff5f5f),  # 203: IndianRed1
        rgb(0xff5f87),  # 204: IndianRed1
        rgb(0xff5faf),  # 205: HotPink
        rgb(0xff5fd7),  # 206: HotPink
        rgb(0xff5fff),  # 207: MediumOrchid1
        rgb(0xff8700),  # 208: DarkOrange
        rgb(0xff875f),  # 209: Salmon1
        rgb(0xff8787),  # 210: LightCoral
        rgb(0xff87af),  # 211: PaleVioletRed1
        rgb(0xff87d7),  # 212: Orchid2
        rgb(0xff87ff),  # 213: Orchid1
        rgb(0xffaf00),  # 214: Orange1
        rgb(0xffaf5f),  # 215: SandyBrown
        rgb(0xffaf87),  # 216: LightSalmon1
        rgb(0xffafaf),  # 217: LightPink1
        rgb(0xffafd7),  # 218: Pink1
        rgb(0xffafff),  # 219: Plum1
        rgb(0xffd700),  # 220: Gold1
        rgb(0xffd75f),  # 221: LightGoldenrod2
        rgb(0xffd787),  # 222: LightGoldenrod2
        rgb(0xffd7af),  # 223: NavajoWhite1
        rgb(0xffd7d7),  # 224: MistyRose1
        rgb(0xffd7ff),  # 225: Thistle1
        rgb(0xffff00),  # 226: Yellow1
        rgb(0xffff5f),  # 227: LightGoldenrod1
        rgb(0xffff87),  # 228: Khaki1
        rgb(0xffffaf),  # 229: Wheat1
        rgb(0xffffd7),  # 230: Cornsilk1
        rgb(0xffffff),  # 231: Grey100
        rgb(0x080808),  # 232: Grey3
        rgb(0x121212),  # 233: Grey7
        rgb(0x1c1c1c),  # 234: Grey11
        rgb(0x262626),  # 235: Grey15
        rgb(0x303030),  # 236: Grey19
        rgb(0x3a3a3a),  # 237: Grey23
        rgb(0x444444),  # 238: Grey27
        rgb(0x4e4e4e),  # 239: Grey30
        rgb(0x585858),  # 240: Grey35
        rgb(0x626262),  # 241: Grey39
        rgb(0x6c6c6c),  # 242: Grey42
        rgb(0x767676),  # 243: Grey46
        rgb(0x808080),  # 244: Grey50
        rgb(0x8a8a8a),  # 245: Grey54
        rgb(0x949494),  # 246: Grey58
        rgb(0x9e9e9e),  # 247: Grey62
        rgb(0xa8a8a8),  # 248: Grey66
        rgb(0xb2b2b2),  # 249: Grey70
        rgb(0xbcbcbc),  # 250: Grey74
        rgb(0xc6c6c6),  # 251: Grey78
        rgb(0xd0d0d0),  # 252: Grey82
        rgb(0xdadada),  # 253: Grey85
        rgb(0xe4e4e4),  # 254: Grey89
        rgb(0xeeeeee),  # 255: Grey93
]

term256_perc = [rgb.to_oklab() for rgb in term256_rgb]

def term256_code(c: RGBColor) -> int:
    """Returns the terminal color code perceptually closest to the given
    color."""
    c_perc = c.to_oklab()
    # Colors 0-15 are often overridden by the terminal.
    closest_code = 16
    closest_dist = perc_distance(c_perc, term256_perc[16])
    for code in range(17, len(term256_perc)):
        dist = perc_distance(c_perc, term256_perc[code])
        if dist < closest_dist:
            closest_code = code
            closest_dist = dist
    return closest_code

###############################################################################
# Color selection
###############################################################################

def grey(L: float) -> RGBColor:
    return OklabColor(L, 0, 0).to_rgb()

def saturate(L: float, h: float) -> RGBColor:
    C_good = 0.0
    color_good = OklchColor(L, 0.0, h).to_rgb()
    dC = 0.125
    for _ in range(12):
        while True:
            C = C_good + dC
            color = OklchColor(L, C, h).to_rgb()
            if not color.in_gamut():
                break
            C_good = C
            color_good = color
        dC /= 2
    return color_good

named_hues = {
        "red": 20,
        "orange": 65,
        "yellow": 110,
        "green": 155,
        "cyan": 200,
        "blue": 245,
        "purple": 290,
        "pink": 335,
}

L_black = 0.24
L_white = 0.90
L_hue = 0.72
L_seq = 0.62
dL_dark = -0.06
dL_light = 0.08
C_seq = 0.105

# palette is the main palette of named colors used by our color scheme.
# Usage:
# - Dark theme only; many hues have poor visibility at text sizes on light
#   backgrounds.
# - "black" is default background. "black_light" is lighter background, and
#   intended for cursor highlighting. "black_dark" is darker background, and
#   intended for static (unmoving) editor elements.
# - "white" is default foreground. "white_dark" is for foreground use on
#   "black_dark" background.
# - All other colors are designed for foreground use on all "black" background
#   variants.
palette = {
        "black_dark": grey(L_black + dL_dark),
        "black": grey(L_black),
        "black_light": grey(L_black + dL_light),
        "white_dark": grey(L_white + dL_dark),
        "white": grey(L_white),
        "grey": grey(L_hue),
} | {h_name: saturate(L_hue, h) for h_name, h in named_hues.items()}

# delims is a short list of unnamed colors that remains distinct at relatively
# small sizes.
delims = [grey(L_seq)] + [OklchColor(L_seq, C_seq, h).to_rgb()
                          for h in (20, 260, 140, 320, 200, 80)]

###############################################################################
# Color schemes
###############################################################################

if __name__ == "__main__":
    argp = argparse.ArgumentParser()
    argsp = argp.add_subparsers(dest="subcmd")
    argp_vim = argsp.add_parser("vim", help="print Vim color scheme")
    args = argp.parse_args()

    if not args.subcmd:
        argp.print_help()
        exit(1)

    elif args.subcmd == "vim":
        print("""" Generated by `jcolor2.py vim`

highlight clear
if exists('syntax_on')
  syntax reset
endif

let colors_name = 'jcolor2'

if !has('gui_running') && !(has('termguicolors') && &termguicolors) && &t_Co != 256
  finish
endif

set background=dark""")
        print()
        for name, c in palette.items():
            c_term = term256_code(c)
            print(f"\" {name}: {c} (cterm={c_term} {term256_rgb[c_term]})")
        print()
        def hi(group: str,
               fg_name: str | None = None,
               bg_name: str | None = None,
               attrs: str | None = None,
               ul_name: str | None = None):
            if fg_name:
                fg = palette[fg_name]
                fg_gui = str(fg)
                fg_term = str(term256_code(fg))
            else:
                fg_gui = "NONE"
                fg_term = "NONE"
            if bg_name:
                bg = palette[bg_name]
                bg_gui = str(bg)
                bg_term = str(term256_code(bg))
            else:
                bg_gui = "NONE"
                bg_term = "NONE"
            if attrs is None:
                attrs = "NONE"
            if ul_name:
                ul = palette[ul_name]
                guisp = " guisp=" + str(ul)
                ctermul = " ctermul=" + str(term256_code(ul))
            else:
                guisp = ""
                ctermul = ""
            print(f"highlight {group} guifg={fg_gui} guibg={bg_gui}{guisp} gui={attrs} ctermfg={fg_term} ctermbg={bg_term}{ctermul} cterm={attrs}")
        hi("Normal", "white", "black")
        print("\n\" From :help E669")
        hi("Comment", "grey")
        hi("Constant", "blue")
        hi("Identifier", "white")
        hi("Statement", "green")
        hi("PreProc", "purple")
        hi("Type", "white")
        hi("Special", "orange")
        hi("Underlined", attrs="underline")
        hi("Bold", attrs="bold")
        hi("Italic", attrs="italic")
        hi("BoldItalic", attrs="bold,italic")
        hi("Ignore", "black")
        hi("Error", "red")
        hi("Todo", "white")
        hi("Added", "green")
        hi("Changed", "blue")
        hi("Removed", "red")
        print()
        hi("ColorColumn", None, "black_dark")
        hi("Conceal", attrs="italic")
        hi("CursorColumn", None, "black_light")
        hi("CursorLine", None, "black_light")
        hi("CursorLineNr", None, "black_light")
        hi("Directory", "blue")
        hi("LineNr", "grey")
        hi("MatchParen", attrs="bold")
        hi("NonText", "grey") # ~ lines after EOF, @ after truncation
        hi("Folded", attrs="italic")
        hi("FoldColumn", "white")
        hi("Pmenu", None, "black_dark")
        hi("PmenuSel", attrs="inverse")
        hi("Search", "yellow", attrs="inverse")
        hi("SignColumn", "white")
        hi("SpecialKey", "grey") # listchars showing tabs
        hi("SpellBad", attrs="undercurl", ul_name="red")
        hi("SpellCap", attrs="undercurl", ul_name="red")
        hi("SpellLocal", attrs="undercurl", ul_name="blue")
        hi("SpellRare", attrs="undercurl", ul_name="yellow")
        hi("StatusLine", "white_dark", "black_dark")
        hi("VertSplit", "grey", "black_dark")
        hi("Visual", attrs="inverse")
        hi("WinSeparator", "grey", "black_dark")
        print()
        hi("CtrlPMatch", attrs="inverse")
        print("\n\" llama.vim")
        hi("llama_hl_fim_hint", "cyan", "black")
        hi("llama_hl_inst_src", "white", attrs="italic")
        hi("llama_hl_inst_virt_proc", "grey", attrs="italic")
        hi("llama_hl_inst_virt_gen", "cyan", attrs="italic")
        hi("llama_hl_inst_virt_ready", "cyan")
        rainbow_colors = ",\n".join(
                f"\\     ['{term256_code(color)}', '{color}']"
                for color in delims)
        print("""
" rainbow_parentheses
if !exists('g:rainbow#colors')
  let g:rainbow#colors = {
\\   'dark': [
%s
\\   ],
\\   'light': [
%s
\\   ] }
endif""" % (rainbow_colors, rainbow_colors))

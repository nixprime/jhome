#!/usr/bin/env python

from __future__ import print_function

import fileinput
import math
import re

import jcolor

CTERM_LAB = {code: jcolor.TERM256_RGB[code].to_xyz().to_lab()
             for code in xrange(16, 256)}

def color_dist(x_lab, y_lab):
    dl = x_lab.L - y_lab.L
    da = x_lab.a - y_lab.a
    db = x_lab.b - y_lab.b
    return math.sqrt(dl*dl + da*da + db*db)

def closest_term_color(srgb):
    lab = srgb.to_xyz().to_lab()
    closest_code = 16
    closest_dist = color_dist(lab, CTERM_LAB[16])
    for code in xrange(17, 256):
        dist = color_dist(lab, CTERM_LAB[code])
        if dist < closest_dist:
            closest_code = code
            closest_dist = dist
    return closest_code

if __name__ == "__main__":
    hex_str_re = re.compile(r"#[0-9a-fA-F]{6}")
    for line in fileinput.input():
        for hex_str in hex_str_re.findall(line):
            code = closest_term_color(jcolor.sRGBColor.from_str(hex_str))
            print("%s => %d (%s)" % (
                    hex_str, code, str(jcolor.TERM256_RGB[code])))


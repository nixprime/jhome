#!/usr/bin/python

import matplotlib.pyplot as plt
import jcolor as jc

bar_width = 1
x_left = 1

for i in range(8):
    plt.bar([x_left], [1], width=bar_width, color=jc.series_color(i))
    x_left += 1
plt.savefig("series_colors.pdf", bbox_inches="tight")
plt.clf()
for i in range(8):
    plt.bar([x_left], [1], width=bar_width, color=jc.fig_fill_color(i))
    x_left += 1
plt.savefig("fig_fill_colors.pdf", bbox_inches="tight")
plt.clf()
for i in range(8):
    plt.bar([x_left], [1], width=bar_width, color=jc.fig_line_color(i))
    x_left += 1
plt.savefig("fig_line_colors.pdf", bbox_inches="tight")


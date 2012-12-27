#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Get the dependencies of a .tex file using strace."""

from __future__ import absolute_import, division, print_function, \
        unicode_literals
import sys
if sys.version_info.major < 3:
    str = unicode
    chr = unichr
    from io import open

import glob
import os
import re


# Check for sh.py
try:
    import sh
    HAVE_SH = True
except ImportError:
    HAVE_SH = False


# Check for strace
if HAVE_SH:
    try:
        sh.strace("true")
        HAVE_STRACE = True
    except sh.ErrorReturnCode:
        HAVE_STRACE = True
    except sh.CommandNotFound:
        HAVE_STRACE = False
else:
    HAVE_STRACE = False
if HAVE_STRACE:
    trace_open = sh.strace.bake(e="trace=open", _no_out=True)


STRACE_OPEN_RE = re.compile('^open\("(.*)", (\w*)\).*$')
def strace_dep_filename(line):
    """Given a line from strace, if the line contains the name of a file
    considered to be a dependency, return the dependency's filename. Otherwise
    return `None`.

    A file is considered to be a dependency if it is opened in read-only and is
    referenced by a relative pathname."""
    m = STRACE_OPEN_RE.match(line)
    if m:
        fn = m.group(1)
        if len(fn) > 0 and not os.path.isabs(fn) and m.group(2) == "O_RDONLY":
            return os.path.normpath(fn)
    return None


def tex_deps_of(basename, latex):
    """Return the dependencies of the TeX file `basename`.tex. If the file's
    dependencies cannot be identified, returns `None`."""
    if HAVE_STRACE:
        try:
            deps = set()
            for open_line in trace_open(latex, "-interaction", "batchmode",
                                        basename, _iter="err"):
                dep = strace_dep_filename(open_line)
                if dep:
                    deps.add(dep)
            return deps
        except sh.ErrorReturnCode:
            return None
    return None


if __name__ == "__main__":

    # Parse command-line arguments
    import argparse
    ap = argparse.ArgumentParser(description="TeX build script.")
    ap.add_argument("basename", type=str, nargs='?', default=None,
                    help="TeX file basename (can be autodetected)")
    ap.add_argument("--latex", type=str, default="pdflatex",
                    help="TeX command to run; defaults to pdflatex")
    args = ap.parse_args()

    # Ensure we have a .tex file
    if args.basename:
        basename = args.basename
    else:
        # Try to find exactly one .tex file in the cwd
        cwd_tex = glob.glob("*.tex")
        if len(cwd_tex) == 0:
            print("Error: No TeX file specified and no TeX files found.")
            sys.exit(1)
        elif len(cwd_tex) > 1:
            print("Error: No TeX file specified and multiple TeX files found.")
            sys.exit(1)
        else:
            basename = cwd_tex[0][:-4]

    # Get the .tex file's dependencies
    deps = tex_deps_of(basename, args.latex)

    # Print the .tex file's dependencies
    if deps:
        for dep in sorted(deps):
            print(dep)
    else:
        print("Warning: Couldn't automatically identify dependencies.")


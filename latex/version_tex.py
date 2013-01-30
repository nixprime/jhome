#!/usr/bin/env python

"""Try to get version information for the current working directory from a
version control system. Write the current date and time, and version
information if available, as LaTeX macros in the file version.tex."""

from __future__ import division

import datetime
import re
import subprocess
import time

def now():
    """Get the current time in the form of an ISO 8601-compliant string."""
    # Get a time.time() timestamp just for timezone calculation purposes
    ts = time.time()
    # Figure out the timezone offset
    tz_offset = datetime.datetime.fromtimestamp(ts) - \
            datetime.datetime.utcfromtimestamp(ts)
    tz_sec = tz_offset.days * 86400 + tz_offset.seconds
    # Get the timezone offset as a nice string
    tz_hr = tz_sec // 3600
    tz_min = (tz_sec // 60) - (tz_hr * 60)
    tz_str = "%+03d%02d" % (tz_hr, tz_min)
    # Finally print the time nicely
    t = datetime.datetime.now()
    return t.strftime("%Y-%m-%dT%H:%M:%S") + tz_str

def run(*args):
    """Run the program whose command-line tokens are ``args`` and return what
    it prints to stdout, stripping trailing and leading whitespace."""
    return subprocess.Popen(args, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE).communicate()[0].strip()

def cwd_git_version(short=False):
    """Get the SHA-1 hash that identifies the current version of the Git
    repository that contains the current working directory. If ``short`` is
    True, the short (7-character) form of the hash will be returned. If the
    current working tree is modified, a plus sign is appended to the end of the
    hash. If the current working directory is not part of a Git repository, or
    if Git is not available, return None."""
    try:
        if short:
            hash = run("git", "rev-parse", "--short", "HEAD")
        else:
            hash = run("git", "rev-parse", "HEAD")
        if len(hash) >= 5 and hash[:5] == "fatal":
            return None
        changes = run("git", "status", "--porcelain", "-uno")
        return hash + ("+" if changes else "")
    except:
        return None

def cwd_hg_version(short=False):
    """Get the Mercurial changeset hash of the repository that contains the
    current working directory. If ``short`` is True, the short (12-character)
    form of the changeset hash will be returned. If the current working copy of
    the repository is modified, a plus sign is appended to the end of the hash.
    If the current working directory is not part of a Mercurial repository, or
    if Mercurial is not available, return None."""
    try:
        if short:
            hash = run("hg", "log", "-l", "1", "--template", "{node|short}\\n")
        else:
            hash = run("hg", "log", "-l", "1", "--template", "{node}\\n")
        if len(hash) >= 5 and hash[:5] == "abort":
            return None
        changes = run("hg", "status", "-q")
        return hash + ("+" if changes else "")
    except:
        return None

def cwd_svn_version():
    """Get the Subversion revision number of the current working directory, as
    returned by svnversion. (Among other things, this means that if the current
    working directory or a subdirectory thereof has been modified, an M will
    appear in the revision number.) If the current working directory is not a
    Subversion working copy, or if svnversion is not available, return
    None."""
    try:
        version = run("svnversion")
        if len(version) >= 11 and version[:11] == "Unversioned":
            return None
        return version
    except:
        return None

def cwd_version(short=False):
    """Get a string identifying the version of the current working directory,
    as provided by a version control system. The string consists of a short
    prefix identifying the VCS, followed by a VCS-specific version
    identifier. If no version information is available, return None."""
    version = cwd_git_version(short)
    if version:
        return "git:" + version
    version = cwd_hg_version(short)
    if version:
        return "hg:" + version
    version = cwd_svn_version()
    if version:
        return "svn:" + version
    return None

def __main():
    version = cwd_version()
    with open("version.tex", 'w') as version_tex:
        version_tex.write("\\newcommand{\\jp@versionid}{%s}\n" % \
                          (version if version else ""))
        version_tex.write("\\newcommand{\\jp@datetime}{%s}\n" % \
                          now().replace("T", "~"))

if __name__ == "__main__":
    __main()

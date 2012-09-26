#!/usr/bin/env python

"""Try to get version information for the current working directory from a
version control system. Write the current date and time, and version
information if available, as LaTeX macros in the file version.tex."""

import datetime
import re
import subprocess
import time

def now():
    """Get a string identifying the current local time."""
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
    return t.strftime("%Y-%m-%d~%H:%M:%S") + tz_str

def run(tokens):
    """Run the program whose command-line tokens are given in tokens and return
    what it prints to stdout."""
    return subprocess.Popen(tokens, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE).communicate()[0].strip()

def is_valid_sha1(s):
    """Returns true if s is a valid SHA-1 hash in hexadecimal and false
    otherwise."""
    if len(s) != 40:
        return False
    hexchars = set(list("0123456789abcdef"))
    for c in s.lower():
        if c not in hexchars:
            return False
    return True

def git_revision():
    """Get the SHA-1 hash that identifies the current version of the Git
    repository that contains the current working directory. If the current
    working tree is modified, append an asterisk (*) to the end of the hash. If
    the current working directory is not part of a Git repository, or if Git is
    not available, return None."""
    try:
        sha = run(["git", "rev-parse", "HEAD"])
        if not is_valid_sha1(sha):
            return None
        status = run(["git", "status"])
        if status.find("Changes not staged for commit") >= 0 or \
                status.find("Changes to be committed") >= 0:
            return sha + '*'
        else:
            return sha
    except:
        return None

def svn_revision():
    """Get the Subversion revision number of the current working directory. If
    the current working copy is modified, append an asterisk (*) to the end of
    the version number. If the current working directory is not a working copy,
    or if SVN is not available, return None."""
    try:
        info = run(["svn", "info"])
        rev_match = re.search("^Revision: (.+)$", info, re.MULTILINE)
        if rev_match is not None:
            rev = rev_match.group(1)
            status = run(["svn", "status"])
            if status != "":
                return rev + '*'
            else:
                return rev
    except:
        return None

if __name__ == "__main__":
    git_rev = git_revision()
    if git_rev is not None:
        revision = "git:" + git_rev
    else:
        svn_rev = svn_revision()
        if svn_rev is not None:
            revision = "svn:" + svn_rev
        else:
            revision = None
    with open("version.tex", 'w') as version_tex:
        if revision is not None:
            version_tex.write("\\newcommand{\\jp@revision}{%s}\n" % revision)
        else:
            version_tex.write("\\newcommand{\\jp@revision}{}\n")
        version_tex.write("\\newcommand{\\jp@datetime}{%s}\n" % now())

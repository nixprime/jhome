#!/usr/bin/env python

import datetime
import re
import subprocess
import time

def now():
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
    return subprocess.Popen(tokens, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE).communicate()[0].strip()

def is_valid_sha1(s):
    if len(s) != 40:
        return False
    hexchars = set(list("0123456789abcdef"))
    for c in s.lower():
        if c not in hexchars:
            return False
    return True

def git_revision():
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
    if revision is not None:
        with open("version.tex", 'w') as version_tex:
            version_tex.write("\\newcommand{\\jp@revision}{%s}\n" % revision)
            version_tex.write("\\newcommand{\\jp@datetime}{%s}\n" % now())

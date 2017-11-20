#
#    Copyright (C) 2005  Distance and e-Learning Centre, 
#    University of Southern Queensland
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

import sys
import os
import difflib
import file_util
from xml_normalize import *


def stringDiff(actual, expected):
    diff = list(difflib.ndiff(actual.splitlines(1), expected.splitlines(2)))
    return "\n".join(diff)

def same(actual, expected, printOutput=True):
    if actual==None and expected==None:
        return True
    if actual==None or expected == None:
        if printOutput:
            print "actual = " + str(actual)
            print "expected = " + str(expected)
            print
        return False
    if actual!=expected:
        if printOutput:
            print stringDiff(actual, expected)
            print
        return False
    return True

def sameXml(actual, expected, printOutput=True):
    if actual==None and expected==None:
        return True
    if actual==None or expected == None:
        if printOutput:
            print "actual = " + str(actual)
            print "expected = " + str(expected)
        return False
    
    try:
        actual = normalizeXml(actual, format=True, stripWhiteOnlyText=True)
    except Exception, e:
        if printOutput:
            print "Actual is not well-formed XML! (or is not a string or dom/node)"
        return False
    try:
        expected = normalizeXml(expected, format=True, stripWhiteOnlyText=True)
    except:
        if printOutput:
            print "Expected is not well-formed XML! (or is not a string or dom/node)"
        return False
    return same(actual, expected, printOutput)

# these wrapper methods avoid output being printed unnecessarily
def assertSame(actual, expected):
    if not same(actual, expected):
        assert False
def assertNotSame(actual, expected):
    if same(actual, expected, False):
        assert False
def assertSameXml(actual, expected):
    if not sameXml(actual, expected):
        assert False
def assertNotSameXml(actual, expected):
    if sameXml(actual, expected, False):
        assert False


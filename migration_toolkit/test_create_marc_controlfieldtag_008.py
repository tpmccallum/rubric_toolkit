
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

import os, os.path, shutil, sys, urlparse, string, re, time
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("foxml_class/python")
from create_marc_controlfield_tag_008 import  *
import xml_util
from dspace_archive import *
from fedora_object import *

def getTestDate():
    now = time.localtime()
    year = repr(now[0]) 
    for i in year.split():
        year = i[2:4]
    month = repr(now[1])
    if len(month) == 1:
        month = "0" + month
    day = repr(now [2])
    if len(day) == 1:
        day = "0" + day
    testDate = year+month+day
    return testDate

def test_getDate():
    date = getDate()
    testDate1 = getTestDate()
    assert date == testDate1
    
def test_getPublicationDate():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/0/marc.xml")
    date = getPublicationDate(input)
    assert date == "2002"
    
def test_getPublicationDate2():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc.xml")
    date = getPublicationDate(input)
    assert date == "1975"
    
def test_getPublicationDate3():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc2.xml")
    date = getPublicationDate(input)
    assert date == None
    
def test_getPublicationDate4():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc3.xml")
    date = getPublicationDate(input)
    assert date == "1234"
    
def test_getPublicationDate5():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc4.xml")
    date = getPublicationDate(input)
    date2 = getAlternateDate(input)
    date046 = getPublicationDate046(input)
    assert date == "1260"
    assert date2 == "1963"
    assert date046 == "1952"
    
def test_getPublicationDate6():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc5.xml")
    date = getAlternateDate(input)
    
    assert date == "1963"

    
def test_createTag():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/0/marc.xml")
    tag = createTag(input)
    testDate2 = getTestDate()
    assert tag == testDate2 +"t2002|||||||                 fr |d"
    
def test_createTag2():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc4.xml")
    tag = createTag(input)
    testDate2 = getTestDate()
    assert tag == testDate2 +"m12601963|||                 eng|d"
    
def test_createTag3():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/2/marc2.xml")
    tag1 = createTag(input)
    testDate3 = getTestDate()
    assert tag1 == testDate3 +"n|||||||||||                 eng|d"
def test_iterate():
    iterate("test_Archive_2")

def test_little_language():
    input = xml_util.xml('<datafield tag="041" ind1=" " ind2=" "><subfield code="a">f</subfield></datafield>')
    outputLanguage = getLanguage(input)
    while len(outputLanguage)<3:
       # make it 3 characters long
        outputLanguage = outputLanguage + " "
    assert outputLanguage == "f  "
    

def test_no_language():
    input = xml_util.xml("create_marc_controlfield_tag_008_test_archive/1/marc.xml")
    tag = createTag(input)
    testDate3 = getTestDate()
    outputTag = testDate3 + "t2002|||||||                 eng|d"
    assert tag == outputTag
    
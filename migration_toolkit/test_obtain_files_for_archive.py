
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

import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata, shutil
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("/migration_toolkit")
from dspace_archive import *
from diff_util import *
from xslt_util import *
import xml_util 
import string
import os
import sys
from obtain_files_for_archive import *

def testObtainFilesForArchiveAuth():
    dspace_archive = "obtain_files_for_archive_test_archive1"
    filename = "testTempFile.xml"
    fileType = "pdf"
    protocol = "http://"
    username = "reserve"
    password = "frantic!"
    obtain_files(dspace_archive, filename, fileType, protocol, username, password)
    path = os.path.exists("obtain_files_for_archive_test_archive1/0/774350pt06.pdf")
    path2 = os.path.exists("obtain_files_for_archive_test_archive1/0/800539pt01.pdf")
    assert path and path2 == True
    
    
def testObtainFilesForArchiveNoAuth():
    dspace_archive = "obtain_files_for_archive_test_archive2"
    filename = "testTempFile.xml"
    fileType = "pdf"
    obtain_files(dspace_archive, filename, fileType)
    path3 = os.path.exists("obtain_files_for_archive_test_archive2/0/774350pt06.pdf")
    path4 = os.path.exists("obtain_files_for_archive_test_archive2/0/Architectural%20Design%20of%20Enterprise%20wide%20Standard%20Operating%20Environments.pdf")
    assert path3 and path4 == True
    
def testObtainFilesForArchiveNoAuth():
    dspace_archive = "obtain_files_for_archive_test_archive2"
    filename = "testTempFile.xml"
    fileType = "pdf"
    obtain_files(dspace_archive, filename, fileType)
    path3 = os.path.exists("obtain_files_for_archive_test_archive2/0/774350pt06.pdf")
    path4 = os.path.exists("obtain_files_for_archive_test_archive2/0/Architectural%20Design%20of%20Enterprise%20wide%20Standard%20Operating%20Environments.pdf")
    assert path3 and path4 == True

def test_get_harvestedFileName1():
    url1 = "http://www.lib.mq.edu.au/catalogue/public/brunner.php?ctype=3&doc=774350pt06.pdf"
    filename1 = get_harvestedFileName(url1)
    assert filename1 == "774350pt06.pdf"
def test_get_harvestedFileName2():
    url2 = "http://www.lib.mq.edu.au/catalogue/ethesis.php?doc=92054403appendices.pdf"
    filename2 = get_harvestedFileName(url2)
    assert filename2 == "92054403appendices.pdf"
def test_get_harvestedFileName3():
    url3 = "http://www.library.mq.edu.au/about/conferences/Architectural%20Design%20of%20Enterprise%20wide%20Standard%20Operating%20Environments.pdf"
    filename3 = get_harvestedFileName(url3)
    assert filename3 == "Architectural%20Design%20of%20Enterprise%20wide%20Standard%20Operating%20Environments.pdf"
    
    
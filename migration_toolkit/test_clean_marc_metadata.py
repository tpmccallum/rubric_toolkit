
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

import os, os.path, shutil, sys, urlparse, string, re
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("foxml_class/python")
from clean_marc_metadata import  *
import xml_util
from dspace_archive import *
from fedora_object import *


def testCleanDate():
    fileName = ("clean_marc_metadata_test_archive1/0/marc.xml")
    
    Date=cleanDate(fileName)
    Title=cleanTitle(fileName)
    
    file = open("clean_marc_metadata_test_archive1/0/marc.xml",'r')
    readme = file.read()
    file.close()
    
    file2 = open("clean_marc_metadata_test_archive1/marc.xml",'r')
    readme2 = file2.read()
    file2.close()
    assert readme == readme2

def testInsertMarcB():
    fileName = ("clean_marc_metadata_test_archive2/0/marcB.xml")
    fileType = "B"
    addMarcTag(fileName, fileType)
    
    fileB = open("clean_marc_metadata_test_archive2/0/marcB.xml",'r')
    readmeB = fileB.read()
    fileB.close()
    
    fileB2 = open("clean_marc_metadata_test_archive2/marc.xml",'r')
    readmeB2 = fileB2.read()
    fileB2.close()
    assert readmeB2 == readmeB
    

    
    #clean up file in archive
    shutil.copy("clean_marc_metadata_test_archive2/replacementMarc.xml","clean_marc_metadata_test_archive2/0/marcB.xml")
      


def testInsertMarcE():
    fileName = ("clean_marc_metadata_test_archive2/0/marcE.xml")
    fileType = "E"
    addMarcTag(fileName, fileType)
    
    fileE = open("clean_marc_metadata_test_archive2/0/marcE.xml",'r')
    readmeE = fileE.read()
    fileE.close()
    
    fileE2 = open("clean_marc_metadata_test_archive2/marcE.xml",'r')
    readmeE2 = fileE2.read()
    fileE2.close()
    assert readmeE2 == readmeE
    

    
    #clean up file in archive
    shutil.copy("clean_marc_metadata_test_archive2/replacementMarcE.xml","clean_marc_metadata_test_archive2/0/marcE.xml")
    


def testInsertMarcW():
    fileName = ("clean_marc_metadata_test_archive2/0/marcW.xml")
    fileType = "W"
    addMarcTag(fileName, fileType)
    
    fileW = open("clean_marc_metadata_test_archive2/0/marcW.xml",'r')
    readmeW = fileW.read()
    fileW.close()
    
    fileW2 = open("clean_marc_metadata_test_archive2/marcW.xml",'r')
    readmeW2 = fileW2.read()
    fileW2.close()
    assert readmeW2 == readmeW
    

    
    #clean up file in archive
    shutil.copy("clean_marc_metadata_test_archive2/replacementMarc.xml","clean_marc_metadata_test_archive2/0/marcW.xml")



def testInsertMarcL():
    fileName = ("clean_marc_metadata_test_archive2/0/marcL.xml")
    fileType = "L"
    addMarcTag(fileName, fileType)
    
    fileL = open("clean_marc_metadata_test_archive2/0/marcL.xml",'r')
    readmeL = fileL.read()
    fileL.close()
    
    fileL2 = open("clean_marc_metadata_test_archive2/marcL.xml",'r')
    readmeL2 = fileL2.read()
    fileL2.close()
    assert readmeL2 == readmeL
    

    
    #clean up file in archive
    shutil.copy("clean_marc_metadata_test_archive2/replacementMarc.xml","clean_marc_metadata_test_archive2/0/marcL.xml")

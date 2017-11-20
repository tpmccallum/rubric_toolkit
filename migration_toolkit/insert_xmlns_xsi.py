
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

'''
Name of the script
insert_xmlns_xsi.py
Location of script
migration_toolkit/insert_xmlns_xsi.py
Purpose of script
This script iterates through FOXML items in a single directory and sets the correct namespace declaration for the MARC XML section of the FOXML

Parameters/Arguments
outputDirectory 
The name of the directory where the FOXML files are located

Syntax
python insert_xmlns_xsi.py outputDirectory

Example
python insert_xmlns_xsi.py foxml_items

'''


import os, os.path, shutil, sys, urlparse, string, re
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("foxml_class/python")

from xml_util import *
from dspace_archive import *
from fedora_object import *

#during the process of creating the foxml objects the xmlns:xsi namespace is erased this code is a find replace to put it back
def insertXmlnsXsi_namespace(foxmlString):
    xmlPos1 = string.find(foxmlString, "<collection")
    xmlStartString = foxmlString[:xmlPos1]
    xmlPos3 = string.find(foxmlString, "<record")
    xmlEndString = foxmlString[xmlPos3-11:]
    xmlMiddleString = foxmlString[xmlPos1:xmlPos3]
    xmlMiddleString = """<collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">"""
    output = xmlStartString + xmlMiddleString + xmlEndString
    return output
#during the process of creating the foxml objects the xmlns:xsi namespace is erased this code is a find replace to put it back USING REGEX
def insertXmlnsXsi_REGEX(foxmlString):
    replaceStr = """<collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">"""    
    output = re.sub("\<collection.*", replaceStr, foxmlString)
    replaceModsString="""<modsCollection xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-2.xsd">"""
    output2 = re.sub("\<modsCollection.*", replaceModsString, output)
    return output2

def iterate(foxmlDirectory):
    if os.path.exists(foxmlDirectory):
        for file in os.listdir(foxmlDirectory):
            if os.path.splitext(file)[1] == ".xml":
                fullPath = os.path.join (foxmlDirectory, file)
                print "processing : " + file
                foxmlFile = open(fullPath, "rb")
                input = foxmlFile.read()
                foxmlInput = insertXmlnsXsi_REGEX(input)
                foxmlFile.close()
                writeFile = open(fullPath, "wb")
                writeFile.write(foxmlInput)
                writeFile.close()
    print "Processing complete"
    
        



def insert_xmlns_xsi():
    foxmlDirectory = sys.argv[1]
    iterate(foxmlDirectory)
    


    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    insert_xmlns_xsi()    


    
    
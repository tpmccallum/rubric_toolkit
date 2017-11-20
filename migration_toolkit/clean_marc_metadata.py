
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

'''
Name of the script
clean_marc_metadata.py
Location of script
migration_toolkit/clean_marc_metadata.py
Purpose of script
The clean_marc_metadata.py  script is used to check if date and title metadata have extra trailing characters. For example: A date field may have a trailing "." or "]". A title field may have a trailing ":". The script iterates through the dspaceArchive subdirectories and cleans the temp XML file contained within. This script is also used as a tool to insert additional marc elements to the marc metadata. The marc elements to be inserted are hard coded into the script, they are inserted into the marc based on the record type. See parameters/Arguments below for more info on specifying record types.
Parameters/Arguments
archiveName 
Name of the archive containing the xml files to be cleaned
tempFileName  
Filename of the xml file to be cleaned
recordType 
The type of record Ethesis(use E) or Brunner (use B) Library Publications (use L) Working Papers (use W) The script will add marc metadata elements that are hard coded into the python script based on the type of record entered here.
Syntax
python clean_marc_metadata.py archiveName tempFileName recordType
Example
python clean_marc_metadata.py dspaceArchive temp.xml E'''


import os, os.path, shutil, sys, urlparse, string, re
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("foxml_class/python")

import xml_util
from dspace_archive import *
from fedora_object import *

def cleanDate(input):
    xml = xml_util.xml(input)
    dateXml = xml.getNodes("//*[local-name()='datafield'][@tag='260']/*[local-name()='subfield'][@code='c']")
    for node in dateXml:
        print node.content
        string1 = node.content
        cleanString = string.replace(string1, "]", "")
        cleanString2 = string.replace(cleanString, ".", "")
        node.setContent(cleanString2)
    xml.saveFile(input)
    xml.close()
    
def cleanKeyword(input):
    xml = xml_util.xml(input)
    keywordXml = xml.getNodes("//*[local-name()='datafield'][@tag='650']/*[local-name()='subfield'][@code='x']")
    for node in keywordXml:
        print node.content
        string1 = node.content
        cleanString = string.replace(string1, "]", "")
        cleanString2 = string.replace(cleanString, ".", "")
        node.setContent(cleanString2)
    xml.saveFile(input)
    xml.close()

def cleanTitle(input):
    xml = xml_util.xml(input)
    titleXml = xml.getNodes("//*[local-name()='datafield'][@tag='245']/*[local-name()='subfield'][@code='a']")
    for node in titleXml:
        print node.content
        titleString = node.content
        titleString = titleString.rstrip(":")
        node.setContent(titleString)       
    xml.saveFile(input)
    xml.close()
    
def addMarcTag(input, recordType):
    file  = open(input, 'rb')
    readFile = file.read()
    splitMarc = readFile.split("</record>")
    marcString = None
    if recordType == "B":
        marcString = """<datafield tag="655" ind1=" " ind2="7">
        <subfield code="a">Brunner digitised document</subfield>
        <subfield code="2">local</subfield>
        </datafield>
        <datafield tag="540" ind1=" " ind2=" ">
        <subfield code="a">PART III. After reasonable investigation, this material has been reproduced in reliance on Part III of the Australian Copyright Act 1968. The electronic form of this material is Copyright Macquarie University, Sydney. Please contact the Macquarie University Copyright Unit with inquiries www.copyright.mq.edu.au</subfield>
        </datafield>"""
        
    if recordType == "E":
        tagPresent = False
        xml = xml_util.xml(input)
        nodes = xml.getNodes("//*[local-name()='datafield'][@tag='655']/*[local-name()='subfield'][@code='a']")
        
        for node in nodes:
            if (node.getContent == "Australasian Digital Thesis") != -1:
                tagPresent = True
        if tagPresent == False:
            marcString = """<datafield tag="655" ind1=" " ind2=" ">
            <subfield code="a">Australasian Digital Thesis</subfield>
            </datafield>"""
        xml.close()
        
    if recordType == "W":
        marcString = """<datafield tag="540" ind1=" " ind2=" ">
        <subfield code="a">Permission for use provided to the Macquarie University Digital Repository by the publisher.</subfield>
        </datafield>"""
    
    if recordType == "L":
        marcString = """<datafield tag="540" ind1=" " ind2=" ">
        <subfield code="a">*</subfield>
        </datafield>"""
    if marcString != None:
        builtString = splitMarc[0] + marcString + "</record>" + splitMarc[1]
        newFile = open(input, 'wb')
        newFile.write(builtString)
        newFile.close()
    file.close()
    
      
    
 
def iterate(TargetArchiveName, marcFile, recordType):
    if os.path.exists(TargetArchiveName):   
        archive = dspaceArchive(TargetArchiveName)
        for item in archive.items:
            print filePath + " is being processed"
            cleanDate(marcFile)
            cleanKeyword(marcFile)
            cleanTitle(marcFile)
            addMarcTag(marcFile, recordType)
            print marcFile + " MARC clean up complete"
    else:
        print "No archive available, " + dspaceArchive + " does not exist."
                 



def cleanMarcData():
    dspaceArchive = sys.argv[1]
    marcFile = sys.argv[2]
    recordType = sys.argv[3]
    iterate(dspaceArchive, marcFile, recordType)
    


    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    cleanMarcData()    

    

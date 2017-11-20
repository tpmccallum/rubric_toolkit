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


'''Create MARC controlfield tag 008
Name of the script
create_marc_controlfield_tag_008.py
Location of script
migration_toolkit/create_marc_controlfield_tag_008.py
Purpose of script
The basic metadata does not have a MARC controlfield tag that is applicable to the contents of each record. This script iterates through the archive and inserts the correct controlfield tag into the marc.xml file.

Parameters/Arguments
ArchiveName 
name of the archive to be accessed.

Syntax
python create_marc_controlfield_tag_008.py ArchiveName

Example
python create_marc_controlfield_tag_008.py dspaceArchive
'''


import os, os.path, shutil, sys, urlparse, string, re
sys.path.append("utils")
sys.path.append("dspace_archive")
sys.path.append("foxml_class/python")

import xml_util
from dspace_archive import *
from fedora_object import *
import time



def createTag(input):
    dateKnown = "t"
    dateCreated = getDate()
    publicationDate = getPublicationDate(input)
    alternateDate = getAlternateDate(input)
    if publicationDate == None:
        publicationDate = getPublicationDate046(input)
        if publicationDate == None:
            dateKnown = "n"
            publicationDate = "||||"
        else:
            dateKnown = "t"
    if alternateDate != None:
        dateKnown = "m"
        secondDate = alternateDate
    else:
        secondDate = "||||"
    

    
    placeOfPublication = "|||"
    
    language = getLanguage(input)
    if language == None:
        language = "eng"
    while len(language)<3:
       # make it 3 characters long
        language = language + " "
    
        
    modifiedRecord = "|"
    
    catalogueSource = "d"
    
    tag = dateCreated + dateKnown + publicationDate + secondDate + placeOfPublication + "                 " + language + modifiedRecord + catalogueSource
    return tag
    
    
    
    
    
def getDate():
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
    date = year+month+day
    return date
def getAlternateDate(input):
    alternateHerbDateNode = input.getNodes("//*[local-name()='datafield'][@tag='046']/*[local-name()='subfield'][@code='l']")
    if alternateHerbDateNode:
        for node in alternateHerbDateNode:
            rawDate = node.content
            if rawDate != None:
                if string.find(rawDate, "/"):
                    rawDate = trimDate(rawDate, "/")
                if string.find(rawDate, "."):
                    rawDate = trimDate(rawDate, ".")
                if len(rawDate) < 4:
                    rawDate = None
                return rawDate
    else:
        return None
    
def getPublicationDate046(input):
    herbDateNode = input.getNodes("//*[local-name()='datafield'][@tag='046']/*[local-name()='subfield'][@code='k']")
    if herbDateNode:
            for node in herbDateNode:
                rawDate = node.content
                if rawDate != None:
                    if string.find(rawDate, "/"):
                        rawDate = trimDate(rawDate, "/")
                    if string.find(rawDate, "."):
                        rawDate = trimDate(rawDate, ".")
                    if len(rawDate) < 4:
                        rawDate = None
                    return rawDate
    else:
        return None

def getPublicationDate(input):
    dateNode = input.getNodes("//*[local-name()='datafield'][@tag='260']/*[local-name()='subfield'][@code='c']")
    
    
    if dateNode:
        for node in dateNode:
            rawDate = node.content
            if rawDate != None:
                if string.find(rawDate, "/"):
                    rawDate = trimDate(rawDate, "/")
                if string.find(rawDate, "."):
                    rawDate = trimDate(rawDate, ".")
                if len(rawDate) < 4:
                    rawDate = None
                return rawDate
    else:
        return None
        
        
        
         
def trimDate(date, char):
    trimmedDate = date.rsplit(char)[date.count(char)]
    return trimmedDate
    
        
    
def getLanguage(input):
    node = input.getNodes("//*[local-name()='datafield'][@tag='041']/*[local-name()='subfield'][@code='a']")
   
    if node:
        languageNode = node
        for subnode in languageNode:      
            return subnode.content
    else:
        return "eng"
 
def iterate(archiveName):
    arc = dspaceArchive(archiveName) 
    for item in arc.items:
        print item.name + " is being processed"
        #fileContents = item.readFile("marc.xml")
        x = item.getRelPathToStream('marc.xml')
        fullPath = os.path.join(archiveName, x)
        print fullPath
        input = xml_util.xml(fullPath)
        print input
        tag = createTag(input)
        node = input.getNode("//*[local-name()='controlfield'][@tag='008']")
        node.setContent(tag)
        input.saveFile(fullPath)
        print item.name + " controlfield tag 008, update complete"
        input.close()
    print "Creating of marc controlfield tag[s] is complete"

def createMarcControlfield():
    archiveName = sys.argv[1]
    iterate(archiveName)
    


    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    createMarcControlfield()    


    
    
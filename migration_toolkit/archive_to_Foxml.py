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
"""

Name of the script
archive_to_foxml.py
Location of script
migration_toolkit/archive_to_foxml.py
Purpose of script
The archive_to_foxml.py script is the Python script that iterates through a dspace archive. The script builds a FOXML file for each item in the dspace archive using the MARC, Dublin Core and MODS metadata contained within each item. All FOXML files created during this process are stored in a single directory (specified as an argument) 
Parameters/Arguments
archiveName 
Full path to name of the archive to be accessed
startNum 
Starting number for the Fedora PID increment
PIDPrefix 
Name of the Fedora PID
outputDirectory 
Name of the directory for storing the FOXML objects
labelPrefix 
Prefix to be added to title for reference. Eg Imported Item:
foxmlObjectState 
Set this to Active (A), Inactive(I) or Deleted (D). 
MARCFileName 
Name of the MARC xml file contained in the Archive.
MARCDataStreamState 
Set this to Active (A), Inactive(I) or Deleted (D). 
DCFileName 
Name of the Dublin Core file contained in the Archive
DCDataStreamState 
Set this to Active (A), Inactive(I) or Deleted (D). 
MODSFileName 
Name of the Dublin Core file contained in the Archive. Set to False if MODS file is not present.
MODSDataStreamState 
Set this to Active (A), Inactive(I) or Deleted (D).  or False if MODS file is not present
URLforNonXmlDataStreams 
If non xml data streams exist in the archive (PDF or full text), a URL is required to access them. If you will be using the python simple server as part of your ingest into Fedora then use http://localhost:8000 for this argument. If you will be using  an existing server during the Fedora ingest then enter the URL path to the existing server where the non xml data streams can be served during ingest. 
If no pdf files or fulltext datastreams exist, set this to FALSE
Note: Remove any trailing slashes (created by tab completion) from arguments before executing script

Syntax
python archive_to_foxml.py archiveName startNum PIDPrefix
outputDirectory labelPrefix foxmlObjectState MARCFileName
MARCDataStreamState DCFileName DCDataStreamState MODSFileName MODSObjectState URLforNonXmlDataStreams 
Example
python archive_to_foxml.py dsapceArchive 0 vital exportedItems Imported_Items A marc.xml A dublin_core.xml A False False http://servername/directoryname
"""

import os, os.path, shutil, sys, urlparse
sys.path.append("utils")
sys.path.append("foxml_class/python")
sys.path.append("dspace_archive")

from xml_util import *
from dspace_archive import *
from fedora_object import *



def getItemTitle(marcXML):
    if marcXML.getNode("//*[local-name()='datafield'][@tag='245']/*[local-name()='subfield'][@code='a']") != None:
        titleContents = marcXML.getNode("//*[local-name()='datafield'][@tag='245']/*[local-name()='subfield'][@code='a']").getContent()
        return titleContents
    else:
        if marcXML.getNode("//*[local-name()='datafield'][@tag='243']/*[local-name()='subfield'][@code='a']") != None:
            titleContents = marcXML.getNode("//*[local-name()='datafield'][@tag='243']/*[local-name()='subfield'][@code='a']").getContent()
            return titleContents
        else:
            return "No Title"

def  main(archiveName, num, pidPrefix, outputDirectory, labelPrefix, foxmlState, marcFile, marcState, dcFile, dcState, modsFile, modsState, baseUrl):
    import libxml2 
    rawArchiveName = os.path.split(archiveName)[1]
    if labelPrefix != "":
        labelPrefix = labelPrefix + " "
    contentModel = "VITAL"
    arc = dspaceArchive(archiveName)
    if not(os.path.exists(outputDirectory)):
        os.mkdir(outputDirectory) 
    for item in arc.items:
        print "Processing item: " + item.name
        pid = pidPrefix + ":" + str(num)
        marcXml = item.readFile(marcFile)
        temp = xml(marcXml)
        title = getItemTitle(temp)
        temp.close()
        objectState = foxmlState
        label = labelPrefix + title
        #create new object
        foxy = fedoraObject(objectState, pid, label, contentModel)
        #add datastream dublin core
        dc = libxml2.parseDoc(item.readFile(dcFile))
        foxy.addDublinCore(dc, dcState)
        marc = libxml2.parseDoc(marcXml)
        foxy.addInlineXML("MARC", "MARCXML Record", marc, marcState)
        #add datastream mods
        if modsFile != "False" or modsState != "False":
            mods = libxml2.parseDoc(item.readFile(modsFile))
            foxy.addInlineXML("MODS", "MODSXML Record", mods, modsState)
            # add the PDF datastreams
            streams = 3
        else:
            streams = 2
        hasPdf = False 
        pathToFile = os.path.split(item.dir)[1] 
        fileList = list()
        for item in item.contents.keys():
            fileList.append(item)
            
        fileList.sort()  
             
        for file in fileList:
            if file.endswith(".pdf"):
                hasPdf = True
                pathPdf = os.path.join(rawArchiveName, pathToFile, file)
                url = baseUrl + "/" + pathPdf
                dsId = "DS" +  str(streams)
                streams = streams + 1
                foxy.addManagedDataStream(dsId, "application/pdf", file, url, fedoraObject.activeState)
        # add the full-text datastream
        if hasPdf == True:            
            textFile = "fulltext"
            pathFullText = os.path.join(rawArchiveName, pathToFile, textFile)
            url = baseUrl + "/" + pathFullText
            foxy.addManagedDataStream("FULLTEXT", "text/plain", "Full Text", url, fedoraObject.activeState)                  
        
        num = num  + 1
        fileName = pidPrefix + str(num) + ".xml"
        foxy.writeFile(os.path.join(outputDirectory,fileName))
        foxy.cleanUp()
    print "Processing complete"   
    
if not(sys.argv[0].endswith("py.test")):
    archiveName = sys.argv[1]
    startNumber = int(sys.argv[2])
    pidPrefix = sys.argv[3]
    outputDirectory = sys.argv[4] 
    labelPrefix = sys.argv[5]
    foxmlState = sys.argv[6]
    marcFile = sys.argv[7]
    marcState = sys.argv[8]
    dcFile = sys.argv[9]
    dcState = sys.argv[10]
    modsFile = sys.argv[11]
    modsState = sys.argv[12]
    baseUrl = sys.argv[13]
    main(archiveName, startNumber, pidPrefix, outputDirectory, labelPrefix, foxmlState, marcFile, marcState, dcFile, dcState, modsFile, modsState, baseUrl)
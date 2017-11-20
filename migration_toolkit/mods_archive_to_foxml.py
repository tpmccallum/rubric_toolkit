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

import os, os.path, shutil, sys, urlparse
sys.path.append("utils")
sys.path.append("foxml_class/python")
sys.path.append("dspace_archive")

from xml_util import *
from dspace_archive import *
from fedora_object import *



def getItemTitle(m):
   #return marcXML.getNode("//datafield[@tag='245']//subfield[@code='a']").getContent()
    if marcXML.getNode("//*[local-name()='datafield'][@tag='245']/*[local-name()='subfield'][@code='a']") != None:
        titleContents = marcXML.getNode("//*[local-name()='datafield'][@tag='245']/*[local-name()='subfield'][@code='a']").getContent()
        return titleContents
    else:
        if marcXML.getNode("//*[local-name()='datafield'][@tag='243']/*[local-name()='subfield'][@code='a']") != None:
            titleContents = marcXML.getNode("//*[local-name()='datafield'][@tag='243']/*[local-name()='subfield'][@code='a']").getContent()
            return titleContents
        else:
            return "No Title"

def  main(archiveName, num, pidPrefix, outputDirectory, labelPrefix, foxmlState,  dcFile, dcState, modsFile, modsState, baseUrl):
    import libxml2 #TODO get rid of this 
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
        
        title = "- TODO - get title"
        
        objectState = foxmlState
        label = labelPrefix + title
        #create new object
        foxy = fedoraObject(objectState, pid, label, contentModel)
        #add datastream dublin core
        dc = libxml2.parseDoc(item.readFile(dcFile))
        foxy.addDublinCore(dc, dcState)
      
        #add datastream mods
        mods = libxml2.parseDoc(item.readFile(modsFile))
        foxy.addInlineXML("MODS", "MODSXML Record", mods, modsState)
         # add the PDF datastreams
        streams = 3
        hasPdf = False 
        pathToFile = os.path.split(item.dir)[1] 
        fileList = list()
        for item in item.contents.keys():
            fileList.append(item)
            
        fileList.sort()  
             
        for file in fileList:
            if file.endswith(".pdf"):
                hasPdf = True
                pathPdf = os.path.join(rawArchiveName, pathToFile, file) #TODO consider changign this may have probs on windows
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

    dcFile = sys.argv[7]
    dcState = sys.argv[8]
    modsFile = sys.argv[9]
    modsState = sys.argv[10]
    baseUrl = sys.argv[11]
    main(archiveName, startNumber, pidPrefix, outputDirectory, labelPrefix, foxmlState, dcFile, dcState, modsFile, modsState, baseUrl)
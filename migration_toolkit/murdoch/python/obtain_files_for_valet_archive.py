
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
sys.path.append("../../utils")
sys.path.append("../../dspace_archive")
from dspace_archive import *
from diff_util import *
from xslt_util import *
import xml_util 
import string
import os
import sys
import shutil
import httplib
import libxml2
import urllib2
import urlparse
import os
import os.path
import re
import unicodedata

def obtainFiles(dspace_archive, filename, pathToDeadLinksFile,  protocol="false", username="false", password="false"):
    #create new file for dead links
    downloadCounter = 0
    deadLinkReport = DeadLinksFile(pathToDeadLinksFile)
    if os.path.exists(dspace_archive):
        archive = dspaceArchive(dspace_archive)
        #loop through items
        for item in archive.items:
            print "Processing Item " + item.name
            fullPath = os.path.join(item.dir, filename)
            xml = xml_util.xml(fullPath)
            fileList = []
            
            #match all urls 
            nodes = xml.getNodes("//text()[contains(.,'http')]")
            sessionNode = xml.getNode("//session")
            sessionNodeContent= sessionNode.content
            
            
            #qualify urls and store in list
            for node in nodes:
                if node.content.startswith("http://") or node.content.startswith("https://"):
                    fileList.append(node.content)
                else:
                    deadLinkReport.reportToScreen(node.content)
                    deadLinkReport.addDeadLinkT(node.content)
                    print "\n\n"
                                    
            #iterate through list of urls
            for urlItem in fileList:
                harvestUrl = cleanUrl(urlItem)
                #determine if link is a downloadable non xml datastream or just a html page
                isHtml = "false"
                isHtml = determineMimeType(harvestUrl)
                content = None  
                if isHtml == "false":
                    #determine if user has entered authentication for downloading datastreams using basic auth
                    if protocol != "false":
                        content= getFile(harvestUrl, protocol, username, password) 
                    else:
                        if harvestUrl.startswith("https://"):
                            content= getFileHttps(harvestUrl)
                        else:
                            content= getFileNoAuth(harvestUrl)
                else:
                    content = getRedirectedFile(harvestUrl)
                    
                if content!= None:
                    harvestedFileName = getHarvestedFileName(harvestUrl)
                    #shorten filename so that file system does not complain
                    correctlySizedFileName = shortenFileName(harvestedFileName)
                    #add datastream to dspace archive
                    item.newStream(correctlySizedFileName, "bundle:ORIGINAL", content)
                    #append valet xml so that it knows about the new datastream 
                    addAttachmentDataToValetXml(xml, correctlySizedFileName, fullPath)
                    #increment the downloadCounter 
                    downloadCounter = downloadCounter + 1
                else:
                    deadLinkReport.reportToScreen(harvestUrl)
                    deadLinkReport.addDeadLinkT(harvestUrl)
                    print "\n\n"
            
            xml.close()
            deadLinkReport.report(sessionNodeContent, item.name)
            deadLinkReport.reset()
        print "\n\n"
    deadLinkReport.closeFile()
    print "total number of downloads = "
    print downloadCounter
    

    
def shortenFileName(bigFileName):
    if len(bigFileName) > 50:
        littleFileName = bigFileName[-50:]
        return littleFileName
    else:
        return bigFileName
        
                 
                
def cleanUrl(url):
    newUrl = string.replace(url, '&amp;', '&')
    return newUrl
    

def addAttachmentDataToValetXml(xml, fileName, pathToSaveTo):
    #create wrapper tag <Attachment> if there are attachments and attachment element tag is not present yet
    if xml.getNode("//Attachments") == None:
        xml.addElement("Attachments")
    #create attachment elements
    originalFilename = xml.createElement("original_filename")
    #set attachment element contents
    originalFilename.setContent(fileName)
    #add attachment inside main Attachments element
    elementsNode = xml.getNode("//Attachments")
    elementsNode.addChild(originalFilename)
    #save file
    xml.saveFile(pathToSaveTo)
    
    
def getFile(location, protocol, username, password):
    print "downloading file...\n"
    passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
    #creates the password manager
    passman.add_password(None, location, username, password)
    authhandler = urllib2.HTTPBasicAuthHandler(passman)
    #create the auth handler
    opener = urllib2.build_opener(authhandler)
    urllib2.install_opener(opener)
    #all calls to urllib2.urlopen will use our handler
    location = location.split("//")[1]
    pagehandle = urllib2.urlopen(protocol + location)
    fileData = pagehandle.read()
    print "download complete\n"
    return fileData 
    

def getFileNoAuth(location):
    fileData = None 
    print "downloading file...\n"   
    try:
        url = urllib2.urlopen(location)
        fileData = url.read()
        if fileData == None:
            url = urllib2.urlopen(location)
            fileData = url.read()
        print "download complete\n"
        return fileData 
    except Exception, errorInfo:
        return None
    
def getFileHttps(location):
    print "downloading file...\n"   
    try:
        HOSTNAME = getHostname(location)
        conn = httplib.HTTPSConnection(HOSTNAME)
        filePath = getFilePath(location)
        if filePath != '':
            conn.putrequest("GET",filePath)
            conn.endheaders()
            response = conn.getresponse()
            print "download complete\n"
            fileData = response.read()
            return fileData
        else:
            return None
    except Exception, errorInfo:
            return None
        
def getRedirectedFile(url):
    HOSTNAME = getHostname(url)
    filePath2 = getFilePath(url)
    if filePath2 != '':
        try:
            redirectedUrl = httplib.HTTPConnection(HOSTNAME)
            redirectedUrl.putrequest("GET",filePath2)
            redirectedUrl.endheaders()
            redirectedResponse = redirectedUrl.getresponse()
            redirectedString = redirectedResponse.read()
            firstSplit = redirectedString.split("a href=\"")
            secondSplit = firstSplit[1].split("\"")
            newUrl = secondSplit[0]
            print "This file has been redirected, attempting to locate file at its new location"
            print newUrl 
            newContents = getFileNoAuth(newUrl)
            return newContents

        except Exception, errorInfo:
                return None
    else:
        return None
    
def getHostname(location):
    tempLocation = location.split("//")
    tempLocation2 = tempLocation[1].split("/", 1)
    HOSTNAME = tempLocation2[0]
    return HOSTNAME

def getFilePath(location):
    try:
        tempLocation = location.split("//")
        tempLocation2 = tempLocation[1].split("/", 1)
        filePathFound = tempLocation2[1]
        filePathFound = "/" + filePathFound   
        return filePathFound
    except Exception, errorInfo:
            return ""

 
def determineMimeType(url):
    try:
        file = urllib2.urlopen(url)
        mimeType = file.info().getheader("Content-Type")
        if mimeType.find("text/html")!= -1:
            return "true"
        else:
            return "false"
    except Exception, errorInfo:
            return "true"

def getHarvestedFileName(harvestUrl):
    fileName = os.path.basename(harvestUrl) 
    return fileName
            
    
    
class DeadLinksFile:
    def __init__(self, pathToDeadLinksFile):
        self.list = []
        #create file name
        self.deadLinksFileName = "non_xml_datastreams_unable_to_be_downloaded.txt"
        #create full path to file
        self.fullPath = os.path.join(pathToDeadLinksFile, self.deadLinksFileName)
        #remove file if it already exists
        if os.path.exists(self.fullPath):
            shutil.os.remove(self.fullPath)
        #create actual file
        self.file = open(self.fullPath, "a")
        self.file.write("The following files were unable to be downloaded by the python script \n") 
        
    
    def addDeadLinkT(self, link):
        self.list.append(link)
        
        
    def report(self, nameOfItem, directoryNumber):
        num = 0
        for singleItem in self.list:
            if singleItem != None:
                if num == 0:
                    self.file.write("Report for item :")
                    self.file.write(nameOfItem)
                    self.file.write(" from directory number :")
                    self.file.write(directoryNumber)
                    self.file.write("\n")
                    num = 1
                self.file.write(singleItem)
                self.file.write("\n")
            self.file.write("\n\n\n")
        
    def reportToScreen(self, link):
        print "no content at..."
        print link
        print "sending broken link to "
        print self.fullPath
        print "\n\n"

    def closeFile(self):
        self.file.close()
    
    def reset(self):
        self.list = []
        
     

arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    protocol = None
    password = None
    username = None
    dspace_archive = sys.argv[1]
    filename = sys.argv[2]
    pathToDeadLinksFile = sys.argv[3]
    length = len(sys.argv)
    if length > 6:
        protocol = sys.argv[4]
        username = sys.argv[5]
        password = sys.argv[6]
        obtainFiles(dspace_archive, filename, pathToDeadLinksFile,  protocol, username, password) 
    else:
        obtainFiles(dspace_archive, filename, pathToDeadLinksFile)

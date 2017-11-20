
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

import sys, re
import urllib
import libxml2
import urllib2
sys.path.append("../dspace_archive")
from dspace_archive import *

class Item:
    def __init__(self, pid):
        self.pid = pid
        self.datastreams = []
    def getPid(self):
        return self.pid
    def addDatastream(self, stream):
        self.datastreams.append(stream)
    def getDatastreamList(self):
        return self.datastreams
    def report(self):
        report = "<div class='item'><h1>" + self.pid + "</h1>"
        if len(self.datastreams) > 0:
            report += "<table>"
            for ds in self.datastreams:
                report += ds.report()
            report += "</table>"
        report += "</div>"
        return report
        

class Datastream:
    def __init__(self, id, label, mimeType, fedoraUrl, datastreamFilePath):
        self.id = id
        self.researchId = "."
        self.mimeType = mimeType
        self.fedoraUrl = fedoraUrl
        self.fileSize = "0"
        if label == "":
            self.label = "Untitled"
        else:
            self.label = label
        self.filePath = datastreamFilePath
    def createFileName(self):
        mimeString = self.mimeType
        ext = mimeString.split("/")[1]
        import os.path
        #TODO Fix this properly using a lookup table
        return self.id + "." +  ext
    #TODO set size
    def getId(self):
        return self.id
    def getLabel(self):
        return self.label
    def getMimeType(self):
        return self.mimeType
    def getFedoraUrl(self):
        return self.fedoraUrl
    def getFilePath(self):
        return self.filePath
    def report(self):
        return "<tr><td><a href='%s'>%s</a></td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>" % (self.filePath, self.id, self.label, self.mimeType, self.researchId, self.fileSize)
    
    
    

def listAllPids(interface):
        pidList = []
        moreToDo = True
        token = None
        while moreToDo:
            url = interface.generateSearchUrl(token)
            parsedUrl = libxml2.parseDoc(interface.getFile(url))
            tokenNode = parsedUrl.xpathEval("//*[local-name() ='token']/text()")
            if len(tokenNode) == 0:
                moreToDo = False
                token = None
            else:
                token = tokenNode[0].serialize()
            for pidNode in parsedUrl.xpathEval("//*[local-name() ='pid']/text()"):
                pid = pidNode.serialize()
                pidList.append(pid)
        return pidList
    
def createDspaceArchive():
    arc = dspaceArchive("dspaceArchive")
    #TODO get the delete method working
    arc.delete()
    arc = dspaceArchive("dspaceArchive")
    return arc

def createDspaceItem(archive):
    item = archive.newItem()
    return item

def createDatastreamInDspaceItem(interface, datastream, dspaceItem):
    data = interface.getFile(datastream.getFedoraUrl())
    datastreamLabel = datastream.createFileName()
    dspaceStream = dspaceItem.newStream(datastreamLabel, "RUBRIC-temp", data)
    if interface.xpathToResearchId != None and datastream.getMimeType() == "text/xml":
        #data = data.replace("\n","")
        #print data
        x = libxml2.parseDoc(data)
        idNodes = x.xpathEval(interface.xpathToResearchId)
        if len(idNodes) > 0:
            datastream.researchId = idNodes[0].get_content()

    datastream.filePath = dspaceItem.getRelPathToStream(datastreamLabel)
    datastream.fileSize = dspaceItem.getStreamSize(datastreamLabel)
 
def iterateThroughItems(pidList, interface):
    archive = createDspaceArchive()
    report = ""
    for pid in pidList:
        #Output object
        dspaceItem = createDspaceItem(archive)
        #Fedora object
        itemObject = Item(pid) 
        datastreamXml = interface.getDatastreamXml(itemObject)
        file = open("datastream_xml.txt", "w")
        file.write(datastreamXml)
        datastreamList = interface.getDatastreamsForItem(itemObject.getPid(), datastreamXml)
        iterateThroughDatastreams(interface, datastreamList, dspaceItem, itemObject)
        report += itemObject.report()
    reportHeader = "<html><title>Research Objects></title><body><table>"
    reportFooter = "</table></body></html>"
    archive.writeIndexPage(reportHeader + report + reportFooter)

def iterateThroughDatastreams(interface, datastreamList, dspaceItem, itemObject):
    for datastream in datastreamList:
        itemObject.addDatastream(datastream)
        createDatastreamInDspaceItem(interface, datastream, dspaceItem)
       

     
 

    

    
    


class FedoraInterface:

    def __init__(self, server = 'localhost', port = "8080", username="fedoraAdmin", password="fedoraAdmin", xpathToResearchId=None):
        self.searchUrl = "http://" + server + ":" + port + "/fedora/"
        self.username = username
        self.password = password
        self.server = server
        self.port =  port
        self.xpathToResearchId = xpathToResearchId
        
    def getFile(self, url):
        import subprocess
        #need to do this to force username and password to be sent
        url = url.replace("//","//%s:%s@" % (self.username, self.password))
        print url
        data = subprocess.Popen([r"curl", url], stdout=subprocess.PIPE).communicate()[0]
        return data

    def generateSearchUrl(self, token):
        if token == None:
            url = self.searchUrl + 'search?query=pid~*&xml=true&pid=true&maxResults=300'
        else:
            url = self.searchUrl + 'search?sessionToken=%s&xml=true' % token
        return url
    def generateDatastreamUrl(self, pid, dsId):
        searchUrlString = self.searchUrl
        url = searchUrlString + "get/" + pid + "/" + dsId
        return url
    def createItemUrl(self, pid):
        itemUrl = "%sget/%s/fedora-system:3/viewItemIndex" % (self.searchUrl, pid)
        return itemUrl
    def getDatastreamXml(self, item):
        itemUrl = self.createItemUrl(item.pid)
        document = libxml2.htmlParseDoc(self.getFile(itemUrl), None)
        return document
    def getDatastreamsForItem(self, itemPid, datastreamXml):
        print "Fetching " + itemPid
        datastreamObjectList = []
        for stream in datastreamXml.xpathEval("//tr[.//a]"):
            print ".",
            label = stream.xpathEval("td[2]")[0].getContent()
            mimeType = stream.xpathEval("td[3]")[0].getContent()
            dsId = stream.xpathEval("td[1]")[0].getContent()
            datastreamFilePath = "/" #set later when we write to the archive
            fedoraUrl = stream.xpathEval("td[2]/a")[0].prop("href")
            datastreamObject = Datastream(dsId, label, mimeType, fedoraUrl, datastreamFilePath)
            datastreamObjectList.append(datastreamObject)
        return datastreamObjectList


    
#main 
def extractResearchObjects(server = 'localhost', port = "8080", username="fedoraAdmin", password="fedoraAdmin", xpathToResearchId=None):
    interface = FedoraInterface(server, port, username, password, xpathToResearchId)
    #TODO make listAllPids a method on the pidList class
    
    pidList = listAllPids(interface)
    iterateThroughItems(pidList, interface)
   

arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    server = None
    port = None
    length = len(sys.argv)
    if length > 1:
        server = sys.argv[1]
        port = sys.argv[2]
        username = sys.argv[3]
        password = sys.argv[4]
        xpathToResearchId = sys.argv[5]
   
        extractResearchObjects(server, port, username, password, xpathToResearchId) 
    else:
        extractResearchObjects() 
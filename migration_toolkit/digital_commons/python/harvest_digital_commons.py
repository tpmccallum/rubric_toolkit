
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

"""
#Name: harvest_digital_commons.py

#Input: Archive Name- name of the archive that houses the individual items
#       temp_file - the name of the file that is housed in an item. This file contains the item's uri that has 
#       links to the pdf and zip documents.


#Purpose/Process:The script scans the temp metadat file for the item uri, accesses the uri and scans that page for any pdf or zip file links.
Theses files are then harvested and stored systematically in each items directory and listed in the 
item's contents file

#Output: revised dspace archive

known issues: This script is sensitive to namespaces in the temp_file given as an argument.
this script uses dc and xsi namespaces. If the target website has namespaces other than this 
then you will need to edit the getIdentifier argument in the call to the xml_util function.


"""
import sys
sys.path.append("../../utils")
sys.path.append("../../dspace_archive")
import xml_util, libxml2, urllib2
sys.path.append("../../dspace_archive_class/python")
from dspace_archive import *

def getFile(location): #TODO: PUT THIS IN UTILS
    try:
        url = urllib2.urlopen(location)
        fileData = url.read()
        return fileData 
    except Exception, errorInfo:
        print errorInfo
        print "Unable to locate, " + location        
        return None

def getIdentifier(dcString):

    dcxml = xml_util.xml(dcString,[("dc","http://purl.org/dc/elements/1.1/"),("xsi","http://www.w3.org/2001/XMLSchema-instance")])
    try:
        pageUrl = dcxml.getNode("//dc:identifier").content
        return pageUrl
    
    #[@xsi:type='dcterms:URI']


    except Exception, errorInfo:
        print errorInfo
        print "Unable to find contents"
        return None

def getContentLinks(pageUrl,html):
    #html = libxml2.htmlParseDoc(pageUrl)
    
    fileList = dict()
    xhtml = libxml2.htmlParseDoc(html,None)

    anchors = xhtml.xpathEval("//a")
    
    for anchor in anchors:
        if anchor.content.endswith(".pdf") or anchor.content.endswith(".zip"): #thesis
            fullURL = anchor.content
            urlListed = fullURL.split('/')
            fileName = urlListed[len(urlListed)-1]
            fileList[fileName] = anchor.prop("href")
        elif anchor.prop("href").find("viewcontent.cgi") > 0: #paper
            fileList["content.pdf"] = anchor.prop("href")
            
    return fileList
    

def harvest_digital_commons(archiveName, dcFileName):
        
    archive = dspaceArchive(archiveName)
    for item in archive.items:
        print item.name
        dc = item.readFile(dcFileName)
        pageUrl = getIdentifier(dc)
        if pageUrl != None:
            html =  getFile(pageUrl)
            links = getContentLinks(pageUrl, html) 
            if links.keys() !=0:
                for fileName in links:
                    print fileName + '******'
                    url = links[fileName]
                    data = getFile(url)
                    if data != None:
                        type = "bundle:ORIGINAL"
                        item.newStream(fileName, type, data)
        else:
            print "pageUrl is Empty"       
        
if not(sys.argv[0].endswith("py.test")):
        archiveName = sys.argv[1] 
        dcFileName = sys.argv[2]
        harvest_digital_commons(archiveName, dcFileName)

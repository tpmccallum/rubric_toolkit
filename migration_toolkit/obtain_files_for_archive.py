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
obtain_files_for_archive.py
Location of script
migration_toolkit/obtain_files_for_archive.py
Purpose of script
The obtain_files_for_archive.py script is a Python script that searches the temp.xml files looking for URL links to external pdf files. Once found, the files are then downloaded by the script and put into the dspaceArchive. Use optional protocol, username and password arguments when files to be harvested require authentication. 
Parameters/Arguments
archiveName
name of the archive to be accessed
tempXmlFile
name of the file in each archive to be accessed
fileType 
file extension of external file to be accessed and downloaded
protocol 
protocol used to access file(optional)
username
username required to access file(optional)
password
password required to access file(optional)
Syntax
python obtain_files_for_archive.py  archiveName tempXmlFile fileType fileType username password
Example
Using Authorization
python obtain_files_for_archive.py  voyagerArchive temp.xml pdf http:// username password
Without Authorization
python obtain_files_for_archive.py  voyagerArchive temp.xml pdf
"""

import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("utils")
sys.path.append("dspace_archive")
from dspace_archive import *
from diff_util import *
from xslt_util import *
import xml_util 
import string
import os
import sys

def get_harvestedFileName(harvestUrl):
    if  harvestUrl.find("/public/") or harvestUrl.find("/restricted/") or harvestUrl.find("ethesis.php?"):
        harvestUrl = harvestUrl.rsplit("=")[-1]
    if  harvestUrl.find("/public/") and harvestUrl.find("/restricted/") and harvestUrl.find("ethesis.php?") == -1:
        harvestUrl = harvestUrl.rsplit("/")[-1] 
    return harvestUrl
    


def obtain_files(dspace_archive, filename, fileType, protocol = "false", username = "false", password = "false"):
    
    if os.path.exists(dspace_archive):
        archive = dspaceArchive(dspace_archive)
        #loop through items
        for item in archive.items:
            print "Processing Item " + item.name
            fullpath = os.path.join(item.dir, filename)
            xml = xml_util.xml(fullpath)
            fileList = []
            
            #match all urls 
            nodes = xml.getNodes("//text()[starts-with(.,'http')]")
           
            #qualify urls
            
            for node in nodes:
                if node.content.endswith(fileType):
                    fileList.append(node.content)
            #get urls
            
            for urlItem in fileList:
                harvestUrl = cleanUrl(urlItem)
                if protocol != "false":
                    Content = getFile(harvestUrl, protocol, username, password) 
                else:
                    Content = getFileNoAuth(harvestUrl)
                if Content != None:
                    pdfFileName = get_harvestedFileName(urlItem)    
                    item.newStream(pdfFileName, "bundle:ORIGINAL", Content)
                else:
                    print "no content"
            
            xml.close()
        
                 
                
def cleanUrl(url):
    newUrl = string.replace(url, '&amp;', '&')
    if newUrl.find("/public/") == -1 and newUrl.find("ethesis.php") == -1:
        urlFinal = newUrl 
    else:
        urlFinal = newUrl + "&accepted=1"
    return urlFinal
    
def getFile(location, protocol, username, password):
    if location.find("/public/") == -1: 
        passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
        #creates the password manager
        passman.add_password(None, location, username, password)
        authhandler = urllib2.HTTPBasicAuthHandler(passman)
        #create the auth handler
        opener = urllib2.build_opener(authhandler)
        urllib2.install_opener(opener)
        #all calls to urllib2.urlopen will use our handler
        location = location.split("//")[1]
        pagehandle = urllib2.urlopen(protocol + location + "&accepted=1")
        fileData = pagehandle.read()
        return fileData 
    else:
        fileData = getFileNoAuth(location)
        return fileData
    
def getFileNoAuth(location):    
    try:
        url = urllib2.urlopen(location)
        fileData = url.read()
        return fileData 
    except Exception, errorInfo:
        print errorInfo
        print "Unable to locate, " + location 
        return None
            

                

arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    protocol = None
    password = None
    username = None
    dspace_archive = sys.argv[1]
    filename = sys.argv[2]
    fileType = sys.argv[3]
    
    length = len(sys.argv)
    if length > 6:
        protocol = sys.argv[4]
        username = sys.argv[5]
        password = sys.argv[6]
        obtain_files(dspace_archive, filename, fileType, protocol, username, password) 
    else:
        obtain_files(dspace_archive, filename, fileType)

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
Obtain Eprints Files for Archive

Name of the script
obtain_eprints_files_for_archive.py

Location of script
migration_toolkit/eprints/obtain_eprints_files_for_archive.py

Purpose of script
The obtain_eprints_files_for_archive.py script is a Python script that searches the temp.xml files looking for URL links to external pdf files. Once found the files are then downloaded by the script and put into the archive.  
Change to the eprints/python directory to run the script.

Parameters/Arguments
archiveName = name of the archive 
tempXmlFile = name of the file in each archive to be accessed

Syntax
python obtain_eprints_files_for_archive.py  archiveName tempXmlFile 

Example
python obtain_eprints_files_for_archive.py  dspaceArchive temp.xml 
'''



import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("../utils")
sys.path.append("../dspace_archive")
from dspace_archive import *
from diff_util import *
from xslt_util import *
import xml_util 
import string
import os
import sys




def obtain_files(dspace_archive, filename):
    if os.path.exists(dspace_archive):
        archive = dspaceArchive(dspace_archive)
         #loop through items
        for item in archive.items:
            print "Processing Item " + item.name
            fullpath = os.path.join(item.dir, filename)
            xml = xml_util.xml(fullpath)
            fileList = []
            #match all urls 
            nodes = xml.getNodes("//text()[contains(.,'http')]" and "//text()[contains(.,'http')]")
            #qualify urls
            for node in nodes:
                splitNode = node.content
                splitNode = splitNode.split(";")
                url = splitNode[1]
                fileList.append(url)
            #get urls
            for urlItem in fileList:
                harvestUrl = cleanUrl(urlItem)
                print urlItem
                content = getFile(harvestUrl)
                if content != None:
                    harvestedFile = urlItem.rsplit("/")[-1] 
                    item.newStream(harvestedFile, "bundle:ORIGINAL", content)
                else:
                    print "no content"
            xml.close()
                 
                
def cleanUrl(url):
    newUrl = string.replace(url, '&amp;', '&')
    return newUrl
    
def getFile(location):
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
    dspace_archive = sys.argv[1]
    filename = sys.argv[2]
    obtain_files(dspace_archive, filename)
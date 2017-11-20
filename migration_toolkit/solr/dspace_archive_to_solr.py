
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

import libxml2, libxslt, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("../utils")
sys.path.append("../dspace_archive")
import  xml_util, xslt_util
from dspace_archive import *

#load existing Archive
inputFileName = sys.argv[1]
XslFilePath = sys.argv[2]
outputFileName = sys.argv[3]
TargetArchiveName = sys.argv[4]
fedoraId = sys.argv[5]
repositoryName = sys.argv[6]
xslt = xslt_util.xslt(XslFilePath)
archive = dspaceArchive(TargetArchiveName)
from solr import *

solrCon = SolrConnection(host='localhost:8983', persistent=True)


for item in archive.items:
    print "Processing item: " + item.name
#try:
    metaString = item.readFile(inputFileName)
    
    styledoc = libxml2.parseFile(XslFilePath)

    style = libxslt.parseStylesheetDoc(styledoc)

    meta = libxml2.parseDoc(metaString)

    
    result = style.applyStylesheet(meta, { "fedora-id": "'" + fedoraId + "'", "repository-root" : "'http://xxx'"})
    
    docNode = result.xpathEval("//doc")[0]
    
 
    fullText = None
    if item.contents.has_key("fulltext"):
        fullText = item.readFile("fulltext")
    elif item.contents.has_key("FULLTEXT.plain"): #Todo fix this when we fix mimetype handling
        fullText = item.readFile("FULLTEXT.plain")
    
    if fullText != None:
        fullText = fullText.replace("&","&amp;").replace("<","&lt;")
        textNode = libxml2.newNode("field")
        textNode.setContent(fullText)
        textNode.newProp("name","text")
        docNode.addChild(textNode)
    
    reposNode = libxml2.newNode("field")
    reposNode.setContent(repositoryName)
    reposNode.newProp("name","repository")
    docNode.addChild(reposNode)
    
    outputString = result.serialize()
    item.newStream(outputFileName, "whatever", outputString)    
     
    print solrCon.doUpdateXML(outputString)
    print solrCon.commit()
    
    



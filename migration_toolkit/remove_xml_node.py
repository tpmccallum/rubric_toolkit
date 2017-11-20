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
Name of the script
remove_xml_node.py
Location of script
migration_toolkit/remove_xml_node.py
Purpose of script
The remove_xml_node.py script is the Python script that iterates through a dspace archive and removes unwanted nodes and their contents from a file (specified as an argument)

Parameters/Arguments
archiveName 
Name of the archive to be accessed
fileName 
Name of the file from which the node is to be removed
xpath 
The xpath to locate the node to be removed

Syntax
python remove_xml_node.py archiveName fileName xpath
Example
python remove_xml_node.py dspaceArchive marc.xml "//*[local-name()='datafield'][@tag='856']"
"""
import sys, os, re
sys.path.append("utils")
sys.path.append("dspace_archive")
import xml_util
from dspace_archive import *

def removeXmlNode(dspaceArchiveName, filename, xpath):
    print dspaceArchiveName
    if os.path.exists(dspaceArchiveName):
        arc = dspaceArchive(dspaceArchiveName)
        
        for item in arc.items:
            print "Processing " + item.name + "."
            filePath = os.path.join(item.dir, filename)
            print filePath
            xml = xml_util.xml(filePath)
            nodeToDelete = xml.getNodes(xpath)
            for node in nodeToDelete:
                nodeContent = node.getContent()
                if nodeContent.find("/public/") != -1 or nodeContent.find("ethesis.php") != -1:  
                    try:
                        node.delete()
                        print "Successfully removed node"
                        xml.saveFile()
                    except Exception, errorInfo:
                        print errorInfo
                        print "The xpath "+ xpath + " did not match a node in "+ filePath + "."
            print "Processing complete."
            xml.close()
            
                
                
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    dspaceArchiveName = sys.argv[1]
    filename = sys.argv[2]
    xpath = sys.argv[3]
    removeXmlNode(dspaceArchiveName, filename, xpath) 
            
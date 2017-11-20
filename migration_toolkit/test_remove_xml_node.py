
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

import sys, shutil
sys.path.append("/migration_toolkit")
from remove_xml_node import *


def testRemoveXmlNode():
    
    #assign values to variables
    dspaceArchive = "remove_xml_node_test_archive"
    filename = "temp.xml"
    xpath = "//*[local-name()='datafield'][@tag='856']"
    
    #call function to remove the xml node specified by the xpath
    removeXmlNode(dspaceArchive, filename, xpath)
    
    #open file in archive that was modified by removeXmlNode function
    modifiedFile = open("remove_xml_node_test_archive/0/temp.xml", "r")
    modifiedFileContents = modifiedFile.read()
    
    #open sample file with 856 tag removed
    sampleFile = open("remove_xml_node_test_archive/temp.xml","r")
    sampleFileContents = sampleFile.read()
    
    assert sampleFileContents == modifiedFileContents

    #Clean up modified file so that test can be run again without manual intervention
    shutil.copy("remove_xml_node_test_archive/original.xml","remove_xml_node_test_archive/0/temp.xml") 
    
    

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
XSL Transform
Name of the script
xsl_transform.py
Location of script
migration_toolkit/xsl_transform.py
Purpose of script
The xsl_transform.py script is a Python script that iterates through a dspace archive. It carries out an XSL transformations on one XML file per item within the archive. A new XML file is created as a  result of each transformation. This file is stored along side the original XML file in the item. 

Parameters/Arguments
InputFile 
Filename of the XML file in the archive to be converted.
XslFilePath 
File path to the stylesheet used for the XSL transformation
OutputFile 
Filename of new XML file that will be generated as part of conversion process
ArchiveName 
Name of the archive to be accessed
RemoveInputFile 
Remove the original XML file file? - set to False

Syntax
python  xsl_transform.py InputFile
XslFilePath  OutputFile ArchiveName RemoveInputFile 
Example
python  xsl_transform.py marc.xml 
xsl/marc_dc.xsl dublin_core.xml dspaceArchive False
"""

import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("utils")
sys.path.append("dspace_archive")
import diff_util, xml_util, xslt_util
from dspace_archive import *

#load existing Archive
inputFileName = sys.argv[1]
XslFilePath = sys.argv[2]
outputFileName = sys.argv[3]
TargetArchiveName = sys.argv[4]
removeInputFileAfterTransform = sys.argv[5]
archive = dspaceArchive(TargetArchiveName)
for item in archive.items:
    print "Processing item: " + item.name
    metaString = item.readFile(inputFileName)
    meta = xml_util.xml(metaString)
    xslt = xslt_util.xslt(XslFilePath)
    temp = meta.applyXslt(xslt)
    dublinCore = str(temp)
    temp.close()
    meta.close()
    xslt.close()
    item.setDublinCoreStream(dublinCore, inputFileName, outputFileName, removeInputFileAfterTransform)
print "Transformation complete"
        
    
    


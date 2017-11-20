
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
Copy separate files from individual archive directories, to a single directory
Name of the script
get_files_from_archive.py
Location of script
migration_toolkit/ get_files_from_archive.py
Purpose of script
This script iterates through the archive and extracts an individual file from each item in the archive. It loads those individual files into a single directory ready for VALET ingest 
Parameters/Arguments
TargetArchiveName
Name of archive containing individual files
outputDirectory
Where individual files will be put
inputFileName
 Name of individual file to be extracted
xpath
 The individual file names for each record will be set to the contents of the node that the xpath matches
valetPid
This is the pid that was configured in your Valet instance, Valet will not pick up the files from the resource directory unless this is set correctly
Syntax
python get_files_from_archive.py  pathToArchive pathToOutputDirectory  inputFileName  xpath  valetPid
Example
python get_files_from_archive.py dspaceArchive /home/valet_files valet.xml “//*[local-name()=’session’]” wmdu
'''
import libxml2, urllib2, shutil, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("utils")
sys.path.append("dspace_archive")
import diff_util, xml_util, xslt_util
from dspace_archive import *

#load existing Archive

targetArchiveName = sys.argv[1]
outputDirectory = sys.argv[2]
inputFileName = sys.argv[3]
xpath = sys.argv[4]
valetPid = sys.argv[5]

archive = dspaceArchive(targetArchiveName)
os.mkdir(outputDirectory)
for item in archive.items:
    print "Processing item: " + item.name
    metaString = item.readFile(inputFileName)
    meta = xml_util.xml(metaString)
    node = meta.getNode(xpath)
    nodeContents = node.getContent()
    node.setContent(valetPid + "-" + nodeContents)
    fileName = node.getContent()
    file = open(os.path.join(outputDirectory, fileName), 'w')
    file.write(meta.serialize())
    meta.close()
    file.close()
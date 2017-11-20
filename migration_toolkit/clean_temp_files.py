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

##    Clean Temp Files

##    Name of the script
##    clean_temp_files.py

##    Location of script
##    migration_toolkit/clean_temp_files.py

##    Purpose of script
##    The clean_temp_files.py script corrects unicode characters in the temp.xml, that can interfere with the migration process. 

##    Parameters/Arguments
##    archiveName 
##    Name of the archive containing the xml files to be cleaned
##    tempFileName  
##    Filename of the xml file to be cleaned

##    Syntax
##    python clean_temp_files.py archiveName tempFileName 
##    Example
##    python clean_temp_files.py eprintsArchive temp.xml

import os, os.path, shutil, sys, urlparse, string, re, pickle
sys.path.append("utils")
sys.path.append("dspace_archive")
import xml_util
from dspace_archive import *

  
    
def cleanString(input, dictionary):
    brokenChar = re.search("\&\w*;", input)

    while brokenChar != None:
        print brokenChar.group()
        input = re.sub(brokenChar.group(), dictionary[brokenChar.group()], input)
        brokenChar = re.search("&\w*;", input) 
    return input
  
   
def iterate(archiveName, fileName): 
    if os.path.exists(archiveName):
        pickleFile = open('binary', 'rb')
        unpickledString = pickle.load(pickleFile)
        dictionary = eval(unpickledString)
        pickleFile.close()
        #loop through Items in Archive
        archive = dspaceArchive(archiveName)
        for item in archive.items:
            print "processing item " + item.name
            originalFile= item.readFile(fileName)
            modifiedFile = cleanString(originalFile, dictionary)
            item.__writeFile__(fileName, modifiedFile)
    print "Cleaning of the temp files is complete"

def cleanTempFiles():
    archiveName = sys.argv[1]
    fileName = sys.argv[2]
    iterate(archiveName, fileName)
    


    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    cleanTempFiles()    


    
    


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
Wrap namespace around file
Name of the script
wrap_namespace_around_file.py
Location of script
migration_toolkit/wrap_namespace_around_file.py
Purpose of script
Large master files are sometimes supplied for migrations, the master file generally has one namespace that wraps the entire file containing multiple records. Once the master file is split into single records (eg temp file produced during split_xml_into_archive.py)  each single temp file  is stored without a namespace declaration. This wrap_namespace_around_file.py script is used to iterate through the dspaceArchive and wrap a namespace declaration around each single temp file, it then saves the result as a new file (see newFile parameter below) 

Parameters/Arguments
tempXmlFile  
Name of the file inside the archive that needs wrapping 
wrapperFile 
The full path to the wrapper file (eg wrapper_file_for_marc_file)
archiveName  
Name of the archive (eg voyagerArchive)
newFile 
The name of the output file ie: marc.xml
Syntax
python wrap_namespace_around_file.py tempXmlFile wrapperFile archiveName newFile
python wrap_namespace_around_file.py temp.xml wrapper_file_for_marc_file voyagerArchive


Wrapper file contents should be as follows
<namespace decleration goes here eg. xmlns:xsi=url etc>
!@#$%^thisStringGetsReplacedSeeCode^%$#@!
<closing tag goes here eg /closing>
"""
import sys,string
sys.path.append("utils")
sys.path.append("dspace_archive")
from xml_util import *
from dspace_archive import *

def wrap(fileName, wrapperFile, archiveName, newFile):
    #open archive
    arc = dspaceArchive(archiveName)
    #loop through items in archive
    for item in arc.items:
        #open xml file
        file1 = item.readFile(fileName)
        #clear out any existing namespaces 
        file2 = string.replace(file1, '<?xml version="1.0"?>', "")
        
        #open wrapper file and read
        wrapper = open(wrapperFile, 'r')
        wrapperText = wrapper.read()  
        if os.path.exists(wrapperFile):
            #wrap wrapper around xml file
            
            
            newContents = string.replace(wrapperText,"!@#$%^thisStringGetsReplacedSeeCode^%$#@!", file2)
            #close files
            wrapper.close()
            #Write new contents over original xml file
            item.__writeFile__(newFile, newContents)
        else: print "unable to locate wrapper file given"
       
        
def wrapFile():
    fileName = sys.argv[1]
    wrapperFile = sys.argv[2]
    archiveName = sys.argv[3]
    newFile = sys.argv[4]
    
    wrap(fileName, wrapperFile, archiveName, newFile)
        
arg = sys.argv[0]
print arg
if not(arg.endswith("py.test")):
    wrapFile()

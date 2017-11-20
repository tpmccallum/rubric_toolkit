
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

import xml.sax.saxutils, sys, re
import libxml2

sys.path.append("../dspace_archive")


from dspace_archive import *

def main(inputFile, archiveName):
    rec = 0
    arc = dspaceArchive(archiveName)
    arc.delete()
    arc = dspaceArchive(archiveName)
    f = open(inputFile, 'r')
    currentElement = None
    thisRecord = libxml2.newNode("record")
    print "Starting"
    for line in f:

        line = xml.sax.saxutils.escape(line.rstrip())
        line = line.decode('CP1252').encode('utf-8')
        if line.startswith("$"):
            if (rec % 1000) == 0:
                print rec
            rec = rec + 1
            doc = libxml2.newDoc("1.0")
            doc.addChild(thisRecord)
            arc.newItem().newXMLStream("temp.xml", "temp", doc)
            
            #thisRecord.freeNode()
            doc.freeDoc()
            thisRecord = libxml2.newNode("record")
            currentElement = None
        elif line.startswith(" "):
            newElement.addContent(line)
        elif line.startswith(";"):
            newElement.addContent( "|" + line[2:])
        else:
            import re
            content = re.sub("^[^ ]+ ","", line)
            tag = re.sub(" .*","", line)  
            newElement = libxml2.newNode(tag)   
            newElement.addContent(content)
            thisRecord.addChild(newElement)
            
        
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    inputFile = sys.argv[1]
    archiveName = sys.argv[2]
   
    main(inputFile, archiveName)
        
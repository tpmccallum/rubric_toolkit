
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

#!/usr/bin/env python
"""
Harvests EXIF metadata from JPEG images as RDF/XML.

Prerequisites
  jpeg2rdf
    Extracts EXIF from JPEG to RDF/Notation3
    http://simile.mit.edu/wiki/JPEG_RDFizer
  rdflib
    Python RDF processing library
    http://rdflib.net

Parameters
  archiveDir  : The DSpace archive directory. Note that if an existing
                directory is specified it will be deleted first
  imageDir    : The directory containing the JPEG images for harvesting
  jpeg2rdfDir : The jpeg2rdf directory
"""

import sys, tempfile, subprocess
import StringIO

sys.path.append("utils")
sys.path.append("dspace_archive")

from dspace_archive import dspaceArchive
from rdflib import ConjunctiveGraph

def findImages(archiveName, dirName, jpeg2rdfDir):
    print "Directory: %s" % dirName
    arc = dspaceArchive(archiveName)
    arc.delete()
    arc = dspaceArchive(archiveName)
    import os
    from os.path import join, getsize
    for root, dirs, files in os.walk(dirName):
        for name in files:
            item = arc.newItem()
            path = os.path.join(root, name)
            item.newFile(path, "IMAGE")
            #Get RDF in N3 format
            print "     File: %s" % name
            tmpFd, tempName = tempfile.mkstemp()
            currDir = os.getcwd()
            os.chdir(jpeg2rdfDir)
            subprocess.call(["./jpeg2rdf.sh", path, tempName], stdout = subprocess.PIPE)
            os.chdir(currDir)
            #Convert from N3 to RDF/XML using RDFLib
            n3g = ConjunctiveGraph()
            n3g.bind("exif", "http://simile.mit.edu/2006/06/ontologies/exif#");
            try:
                n3f = open(tempName)
                n3g = n3g.parse(n3f, format="n3")
                n3f.close()
                os.remove(tempName)
                rdfxml = StringIO.StringIO()
                n3g.serialize(destination=rdfxml, format="xml")
                item.newStream("rdf.xml", "rdf", rdfxml.getvalue())
                rdfxml.close()
            except IOError:
                print "WARN: Failed converting %s to RDF/XML" % tempName
                pass

findImages(sys.argv[1], sys.argv[2], sys.argv[3])

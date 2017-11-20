
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

import sys, os
from aanro_dump_to_dspace_archive import *

def test_aanro_dump_to_dspace_archive():
    sourceFile = "testData/sourceFileAANRO.txt"
    target = "testData/samplePublicationXml.xml"
    dspaceArchive = "testData/archive"
    
    main(sourceFile, dspaceArchive)
    
    sourceData = open(sourceFile, 'r').read()
    target = open(target, 'r').read()
    compareData = open(os.path.join(dspaceArchive, "0/temp.xml")).read()
    assert target == compareData
    

def test_aanro_dump_to_dspace_archive():
    sourceFile = "testData/encoding.txt"
    target = "testData/encoding_target.xml"
    dspaceArchive = "testData/archive"
    
    main(sourceFile, dspaceArchive)
    
    sourceData = open(sourceFile, 'r').read()
    target = open(target, 'r').read()
    compareData = open(os.path.join(dspaceArchive, "0/temp.xml")).read()
    assert target == compareData
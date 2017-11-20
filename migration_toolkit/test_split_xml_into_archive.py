
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
sys.path.append("utils")
sys.path.append("dspace_archive")
from xml_util import *
from dspace_archive import *
from split_xml_into_archive import *

def test_split():
    testXml = xml("<a><b>1</b><b>2</b><b>3</b></a>")
    split(testXml,"split_xml_into_archive_test_archive","//b","b.xml", "False")
    arc = dspaceArchive("split_xml_into_archive_test_archive")
    assert arc.items[0].readFile("b.xml") == "<b>1</b>"
    assert arc.items[1].readFile("b.xml") == "<b>2</b>"
    shutil.rmtree("split_xml_into_archive_test_archive")
    
    
    
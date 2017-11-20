
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


import sys,string
sys.path.append("utils")
sys.path.append("dspace_archive")
from xml_util import *
from dspace_archive import *
from wrap_namespace_around_file import *

def test_wrapFile():
    #open xml files read and compare
    file = open("wrap_namespace_around_file_test_archive1/0/new_file.xml","rb")
    xmlFile = file.read()
    file2 = open("wrap_namespace_around_file_test_data/wrapped_file.xml",'rb')
    xmlFile2 = file2.read()
    assert xmlFile == xmlFile2
    file.close()
    file2.close()
    
       
        

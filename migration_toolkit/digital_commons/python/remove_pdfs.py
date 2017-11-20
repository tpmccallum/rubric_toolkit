
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

import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("../../utils")
sys.path.append("../../../data-migration-scripts/dspace_archive_class/python")
from dspace_archive import *
from diff_util import *
from xslt_util import *
from xml_util import *




def remove_pdfs(foxmlDirectory):
    if os.path.exists(foxmlDirectory):
        for folder in os.listdir(foxmlDirectory):
            fullPath = os.path.join (foxmlDirectory, folder)
            print fullPath
            for file in os.listdir(fullPath):
                if os.path.splitext(file)[1] == ".pdf":
                    print file
                    filePath = os.path.join(fullPath, file)
                    os.remove(filePath)
                   
            
    
           


    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    dspace_archive = sys.argv[1]
    remove_pdfs(dspace_archive)    


    
    
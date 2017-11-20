
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

"""This script searches through the dspace style archive and returns the name of the file and the name of the item that it is 
stored in, based on a keyword that you enter. You have the option to check different file types as part of your search. Limiting the file types can drastically improve the search time.__doc__
Argument 1 = Archive Name 
Argument 2 = Key word or phrase "must be given in " "
Argument 3 = Type pdf if you want to search PFD documents in the archive or False if you do not want to search PDF files 
             in the archive.
Argument 4 = Type xml if you want to search XML documents in the archive or False if you do not want to search XML files 
             in the archive. (searching dublin core xml or marc xml is the quickest way as it contains author and title info) 
Argument 5 = Type txt if you want to search PLAIN TEXT documents in the archive or False if you do not want to search PLAIN TEXT files 
             in the archive.
        
  

Output writes the output to the screen

"""
import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata
sys.path.append("utils")
sys.path.append("dspace_archive")
from dspace_archive import *
from diff_util import *
from xslt_util import *
from xml_util import *
import string
import os
import sys




def locate_file(dspace_archive, key, pdf, xml, txt):
    if os.path.exists(dspace_archive):
        for folder in os.listdir(dspace_archive):
            fullPath = os.path.join (dspace_archive, folder)
            for file in os.listdir(fullPath):
                if pdf != "False":
                    filePath = os.path.join(fullPath, file)
                    if os.path.splitext(file)[1] == ".pdf":
                        file= open(filePath,'rb')
                        content = file.read()
                        match = string.count(content, key)
                        if match != -1: 
                            if match == 1: 
                                print "The keyword occured " + repr(match) + " time in " + filePath + "."
                            elif match > 1: 
                                print "The keyword occured " + repr(match) + " times in " + filePath + "."
                if xml != "False":
                    filePath = os.path.join(fullPath, file)
                    if os.path.splitext(file)[1] == ".xml":
                        file= open(filePath,'rb')
                        content = file.read()
                        match = string.count(content, key)
                        if match != -1: 
                            if match == 1: 
                                print "The keyword occured " + repr(match) + " time in " + filePath + "."
                            elif match > 1: 
                                print "The keyword occured " + repr(match) + " times in " + filePath + "."
                if txt != "False":
                    filePath = os.path.join(fullPath, file)
                    if os.path.splitext(file)[1] == ".txt":
                        file= open(filePath,'rb')
                        content = file.read()
                        match = string.count(content, key)
                        if match != -1: 
                            if match == 1: 
                                print "The keyword occured " + repr(match) + " time in " + filePath + "."
                            elif match > 1: 
                                print "The keyword occured " + repr(match) + " times in " + filePath + "."

arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    dspace_archive = sys.argv[1]
    key = sys.argv[2]
    pdf = sys.argv[3]
    xml = sys.argv[4]
    txt = sys.argv[5]
    locate_file(dspace_archive, key, pdf, xml, txt)    


    
    
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

import sys
import os
import libxml2
import tempfile
import re


def normalizeXml(xml, format=True, stripWhiteOnlyText=True):  #, stripComments=False, stripPIs=False
    if type(xml)!=type(""):
        xml = xml.serialize()
    dom = libxml2.parseDoc(xml)
    if stripWhiteOnlyText:
        textNodes = dom.xpathEval("//text()")
        #print len(textNodes)
        regex = re.compile("^\s*$")
        for node in textNodes:
            if regex.match(node.content)!=None:
                node.unlinkNode()
            else:
                pass
                #print "text = '%s'" % node.content
        
    if format:
        filename = tempfile.mktemp()
        dom.saveFormatFile(filename, 1)
        dom = libxml2.parseFile(filename)
        os.remove(filename)
    result = dom.c14nMemory()
    dom.free()
    return result
    


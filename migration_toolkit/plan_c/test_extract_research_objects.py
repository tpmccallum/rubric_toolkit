
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
from extract_research_objects import *

#test Datastream Class
def testDatastreamClass():
    stream = Datastream("SOURCE1","Microsoft Word - Draft RQF Technical Specifications", "application/pdf", "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1", "0/1/")
    assert stream.id == "SOURCE1"
    assert stream.label == "Microsoft Word - Draft RQF Technical Specifications"
    assert stream.mimeType == "application/pdf"
    assert stream.fedoraUrl == "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1"
    assert stream.filePath == "0/1/" 
def testDatastreamReport():
    stream2 = Datastream("SOURCE1","Microsoft Word - Draft RQF Technical Specifications", "application/pdf", "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1", "0/1/")    
    datastreamOutput = stream2.report()
    assert datastreamOutput == "<tr><td><a href='0/1/'>SOURCE1</a></td><td>Microsoft Word - Draft RQF Technical Specifications</td><td>application/pdf</td><td>.</td><td>0</td></tr>"
def testCreateFileName():
    stream2 = Datastream("SOURCE1","Microsoft Word - Draft RQF Technical Specifications", "application/pdf", "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1", "0/1/")    
    fileName =  stream2.createFileName()
    assert fileName == "SOURCE1.pdf"
#test Item Class
def testItemClass():
    #create Datastream object 1
    stream = Datastream("SOURCE1","Microsoft Word - Draft RQF Technical Specifications", "application/pdf", "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1", "0/1/")
    #create Datastream object 2
    stream2 = Datastream("DC","Dublin Core Metadata", "text/xml", "http://139.86.13.194:8080/fedora/get/vital:1/DC", "0/1/")
    #create Item object
    i = Item("PID:001")
    #add datastream 1 to item
    i.addDatastream(stream)
    #add datastream 2 to item
    i.addDatastream(stream2)
    #get datastream list
    list = i.getDatastreamList()
    assert list[0].getId() == "SOURCE1"
    assert list[0].getLabel() == "Microsoft Word - Draft RQF Technical Specifications"
    assert list[0].getMimeType() == "application/pdf"
    assert list[0].getFedoraUrl() == "http://139.86.13.194:8080/fedora/get/vital:1/SOURCE1"
    assert list[0].getFilePath() == "0/1/"
def testItemReport():
     #create Item object
    i = Item("PID:001")
    datastreamOutput = i.report()
    assert datastreamOutput == "<div class='item'><h1>PID:001</h1></div>"
    

#test FedoraInterface Class
def testGenerateDatastreamUrl():
    i = FedoraInterface("localhost", "8080")
    pid = "PID:001"
    dsId = "SOURCE1"
    url = i.generateDatastreamUrl(pid, dsId)
    assert url == "http://localhost:8080/fedora/get/PID:001/SOURCE1"
    
def testCreateItemUrl():
    interface = FedoraInterface("localhost", "8080")
    itemUrl = interface.createItemUrl("PID:001")
    assert itemUrl == "http://localhost:8080/fedora/get/PID:001/fedora-system:3/viewItemIndex"
 
def testGetDatastreamsForItem():
    interface = FedoraInterface("none","80")
    itemIndex = libxml2.htmlParseFile("ViewItemIndex.html", None)
    datastreams = interface.getDatastreamsForItem("001", itemIndex)
    assert len(datastreams) == 2
    stream = datastreams[0]
    assert stream.id == "DS1"
    assert stream.label == "MARCXML Record"
    assert stream.mimeType == "text/xml"
    assert stream.fedoraUrl == "http://rubric-usc-trial.usq.edu.au:8080/fedora/get/usc:269/DS1"
    assert stream.filePath == "/"    
  



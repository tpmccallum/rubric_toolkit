
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
This module defines test of the dublin_core module
"""
import libxml2, sys, dublin_core
sys.path.append("../../utils")
import diff_util

def test_addTitle():
    testXml = """<?xml version="1.0" encoding="UTF-8"?>
                 <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                     <dc:title>This is a test title</dc:title>
                 </oai_dc:dc>
              """
    testXmlDoc = libxml2.parseDoc(testXml)
    testVitalDublinCore = dublin_core.vitalDublinCore()
    testVitalDublinCore.addTitle("This is a test title")
    assert diff_util.sameXml(testVitalDublinCore.serialize(), testXmlDoc.serialize())

def test_addCreator():
    testXml = """<?xml version="1.0" encoding="UTF-8"?>
                 <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                     <dc:creator>James Bond</dc:creator>
                 </oai_dc:dc>
              """
    testXmlDoc = libxml2.parseDoc(testXml)
    testVitalDublinCore = dublin_core.vitalDublinCore()
    testVitalDublinCore.addCreator("James Bond")
    assert diff_util.sameXml(testVitalDublinCore.serialize(), testXmlDoc.serialize())

def test_addAllNodes():
    testXmlDoc = libxml2.parseFile("../xml_data/test_dublin_core.xml")
    testVitalDublinCore = dublin_core.vitalDublinCore()
    testVitalDublinCore.addTitle("This is a test title")
    testVitalDublinCore.addCreator("This is a test author")
    testVitalDublinCore.addSubject("This is a test subject")
    testVitalDublinCore.addDescription("This is a test description")
    testVitalDublinCore.addPublisher("This is a test publisher")
    testVitalDublinCore.addContributor("This is a test contributor")
    testVitalDublinCore.addDate("This is a test date")
    testVitalDublinCore.addType("This is a test type")
    testVitalDublinCore.addFormat("This is a test format")
    testVitalDublinCore.addIdentifier("This is a test identifier")
    testVitalDublinCore.addSource("This is a test source")
    testVitalDublinCore.addLanguage("This is a test language")
    testVitalDublinCore.addRelation("This is a test relation")
    testVitalDublinCore.addCoverage("This is a test coverage")
    testVitalDublinCore.addRights("This is a test right")
    assert diff_util.sameXml(testVitalDublinCore.serialize(), testXmlDoc.serialize())
    
    
    
    
    
    

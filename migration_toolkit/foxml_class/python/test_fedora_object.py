
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
Module to test the fedora_object.py class and associated object and properties
"""



import sys, libxml2, os.path, unicodedata
sys.path.append("../../utils")
import diff_util, xml_normalize, xml_util
from fedora_object import *

def test_fedoraObject():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    testxml = libxml2.parseFile("../xml_data/rubric_base_foxml.xml")
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())

def test_mergeXMLDocs():
    # test without a namespace
    parentXML = libxml2.parseDoc("<a><b/></a>")
    childXML = libxml2.parseDoc("<c>Hello World</c>")
    expectedXML = libxml2.parseDoc("<a><b><c>Hello World</c></b></a>")
    xpath = "//b"
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    mergedXML = foxml.mergeXMLDocs(parentXML, childXML, xpath, None)
    assert diff_util.sameXml(mergedXML.serialize(), expectedXML.serialize())
    
    #Test with non ascii characters
    parentXML = libxml2.parseDoc("<a><b/></a>")
    unicodeXML = libxml2.parseFile("../xml_data/umlaut.xml")
    expectedXML = libxml2.parseFile("../xml_data/merged-umlaut.xml")
    mergedXML = foxml.mergeXMLDocs(parentXML, unicodeXML, xpath, None)
    assert diff_util.sameXml(mergedXML.serialize(), expectedXML.serialize())
    #Merge changes the parent doc!
    #assert diff_util.sameXml(parentXML.serialize(), expectedXML.serialize())

     # test with a namespace
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    parentXML = libxml2.parseDoc(foxml.serialize())
    xpathContext = parentXML.xpathNewContext()
    xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")
    childXML = libxml2.parseFile("../xml_data/rubric_DC.xml")
    expectedXML = libxml2.parseFile("../xml_data/rubric_mergeXML_test.xml")
    expectedXML = libxml2.parseDoc(xml_normalize.normalizeXml(expectedXML))
    xpath = "//foxml:digitalObject"
    mergedXML = foxml.mergeXMLDocs(parentXML, childXML, xpath, xpathContext)
    assert diff_util.sameXml(mergedXML.serialize(), expectedXML.serialize())


def test_addDublinCore():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    #testxml = libxml2.parseFile("../xml_data/rubric_with_DC_A.xml")
    #testxml = libxml2.parseFile("../xml_data/rubric_with_DC_B.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_DC_C.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())

def test_addInlineXML():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    inlineXML = libxml2.parseFile("../xml_data/rubric_inlineXML.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    #testxml = libxml2.parseFile("../xml_data/rubric_with_inlineXML_A.xml")
    #testxml = libxml2.parseFile("../xml_data/rubric_with_inlineXML_B.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_inlineXML_C.xml")
    foxml.addInlineXML("rubric", "rubric-inline", inlineXML, fedoraObject.inactiveState)
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())

def test_addExternalDataStream():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    inlineXML = libxml2.parseFile("../xml_data/rubric_inlineXML.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_external_datastream.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("rubric", "rubric-inline", inlineXML, fedoraObject.inactiveState)
    foxml.addExternalDataStream("rubric-external", "application/pdf", "rubric-test-external-pdf", "http://localhost/test.pdf", fedoraObject.activeState)
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())

def test_addRedirectedDataStream():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    inlineXML = libxml2.parseFile("../xml_data/rubric_inlineXML.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_redirected_datastream.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("rubric", "rubric-inline", inlineXML, fedoraObject.inactiveState)
    foxml.addExternalDataStream("rubric-external", "application/pdf", "rubric-test-external-pdf", "http://localhost/test.pdf", fedoraObject.activeState)
    foxml.addRedirectedDataStream("rubric-redirected", "image/jpeg", "rubric redirected jpg image", "http://localhost/redirected.jpg", fedoraObject.activeState)
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())
    
def test_addManagedDataStream():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    inlineXML = libxml2.parseFile("../xml_data/rubric_inlineXML.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_managed_datastream.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("rubric", "rubric-inline", inlineXML, fedoraObject.inactiveState)
    foxml.addExternalDataStream("rubric-external", "application/pdf", "rubric-test-external-pdf", "http://localhost/test.pdf", fedoraObject.activeState)
    foxml.addRedirectedDataStream("rubric-redirected", "image/jpeg", "rubric redirected jpg image", "http://localhost/redirected.jpg", fedoraObject.activeState)
    foxml.addManagedDataStream("rubric-managed", "image/jpeg", "rubric managed jpg image", "http://localhost/managed.jpg", fedoraObject.activeState)
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())

def test_writeFile():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL2")
    inlineXML = libxml2.parseFile("../xml_data/rubric_inlineXML.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_DC.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("rubric", "rubric-inline", inlineXML, fedoraObject.inactiveState)
    foxml.addExternalDataStream("rubric-external", "application/pdf", "rubric-test-external-pdf", "http://localhost/test.pdf", fedoraObject.activeState)
    foxml.addRedirectedDataStream("rubric-redirected", "image/jpeg", "rubric redirected jpg image", "http://localhost/redirected.jpg", fedoraObject.activeState)
    foxml.addManagedDataStream("rubric-managed", "image/jpeg", "rubric managed jpg image", "http://localhost/managed.jpg", fedoraObject.activeState)
    foxml.writeFile("/tmp/foxml_test_output.xml")
    assert os.path.exists("/tmp/foxml_test_output.xml")

def test_typicalUse():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL")
    inlineXML = libxml2.parseFile("../xml_data/rubric_vital_marcxml.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_vital_DC.xml")
    testxml = libxml2.parseFile("../xml_data/rubric_with_vital_data.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("MARC", "MARCXML", inlineXML, fedoraObject.inactiveState)
    foxml.addManagedDataStream("DS1", "application/pdf", "Journal Article", "http://localhost/managed.pdf", fedoraObject.activeState)
    foxml.writeFile("/tmp/foxml_test_output.xml")
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())
    assert os.path.exists("/tmp/foxml_test_output.xml")
    #testOutput = libxml2.parseFile("/tmp/foxml_test_output.xml")
    #assert diff_util.sameXml(testOutput.serialize(), testxml.serialize())
    
    
def test_Unicode_characters():
    foxml = fedoraObject(fedoraObject.inactiveState, "test:99", "test import object", "VITAL")
    inlineXML = libxml2.parseFile("../xml_data/unicode_input.xml")
    dublinCore = libxml2.parseFile("../xml_data/rubric_vital_DC.xml")
    testxml = libxml2.parseFile("../xml_data/unicode_output.xml")
    foxml.addDublinCore(dublinCore, fedoraObject.inactiveState)
    foxml.addInlineXML("MARC", "MARCXML", inlineXML, fedoraObject.inactiveState)
    foxml.addManagedDataStream("DS1", "application/pdf", "Journal Article", "http://localhost/managed.pdf", fedoraObject.activeState)
    foxml.writeFile("/tmp/foxml_test_output.xml")
    assert diff_util.sameXml(foxml.serialize(), testxml.serialize())
    assert os.path.exists("/tmp/foxml_test_output.xml")
    #testOutput = libxml2.parseFile("/tmp/foxml_test_output.xml")
    #assert diff_util.sameXml(testOutput.serialize(), testxml.serialize())
    



  
    
    
    
    
    
    
    
    
    





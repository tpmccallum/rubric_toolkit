
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
This module defines a class that can be used to construct an object that
represent a set of Dublin Core metadata
"""
import libxml2, sys
sys.path.append("../../utils")
import xml_normalize

class vitalDublinCore(object):
    """
    A class used to generate Dublin Core acceptable to VITAL
    """

    def __init__(self):
        """
        The constructor taks no arguments, but builds the basic boilerplate
        for the dublin core in memory
        """
        baseXml = """<?xml version="1.0" encoding="UTF-8"?>
                         <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                         </oai_dc:dc>
                  """

        self.xml = libxml2.parseDoc(baseXml)
        
    def addTitle(self, title):
        """
        Add a title element to the Dublin Core
        """
        newNode = "<dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + title + "</dc:title>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addCreator(self, creator):
        """
        Add a creator element to the Dublin Core
        """
        newNode = "<dc:creator xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + creator + "</dc:creator>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addSubject(self, subject):
        """
        Add a subject to the Dublin Core
        """
        newNode = "<dc:subject xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + subject + "</dc:subject>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addDescription(self, description):
        """
        Add a description element to the Dublin Core
        """
        newNode = "<dc:description xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + description + "</dc:description>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addPublisher(self, publisher):
        """
        Add a publisher element to the Dublin Core
        """
        newNode = "<dc:publisher xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + publisher + "</dc:publisher>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addContributor(self, contributor):
        """
        Add a contributor element to the Dublin Core
        """
        newNode = "<dc:contributor xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + contributor + "</dc:contributor>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addDate(self, date):
        """
        Add a date element to the Dublin Core
        """
        newNode = "<dc:date xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + date + "</dc:date>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addType(self, dcType):
        """
        Add a type element to the Dublin Core
        """
        newNode = "<dc:type xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + dcType + "</dc:type>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addFormat(self, format):
        """
        Add a format element to the Dublin Core
        """
        newNode = "<dc:format xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + format + "</dc:format>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addIdentifier(self, identifier):
        """
        Add an identifier element to the Dublin Core
        """
        newNode = "<dc:identifier xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + identifier + "</dc:identifier>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addSource(self, source):
        """
        Add a source element to the Dublin Core
        """
        newNode = "<dc:source xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + source + "</dc:source>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addLanguage(self, language):
        """
        Add a language element to the Dublin Core
        """
        newNode = "<dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + language + "</dc:language>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addRelation(self, relation):
        """
        Add a relation element to the Dublin Core
        """
        newNode = "<dc:relation xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + relation + "</dc:relation>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addCoverage(self, coverage):
        """
        Add a coverage element to the Dublin Core
        """
        newNode = "<dc:coverage xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + coverage + "</dc:coverage>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def addRights(self, rights):
        """
        Add a rights element to the Dublin Core
        """
        newNode = "<dc:rights xmlns:dc=\"http://purl.org/dc/elements/1.1/\">" + rights + "</dc:rights>"

        self.xml = self.mergeXmlDocs(self.xml, newNode)

    def serialize(self):
        """
        Serialize the Dublin Core XML
        """
        return xml_normalize.normalizeXml(self.xml.serialize())

    def mergeXmlDocs(self, parent, child):
        """
        Merge the child XML fragment into the parent XML fragment at the location specified by the xpath
        The following arguments are required
        - parent, the parent XML fragment
        - child, the child XML fragment (as a string)
        """
        childDoc = libxml2.parseDoc(child)
        childRootNode = childDoc.getRootElement()
        parentRootNode = parent.getRootElement()
        parentRootNode.addChild(childRootNode)
        return parent

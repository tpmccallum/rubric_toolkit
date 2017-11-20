
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
This module defines a class used to generate a Fedora Object XML, FOXML, file.
"""
import libxml2, sys, unicodedata
sys.path.append("../../utils")
import xml_normalize

class fedoraObject(object):
    """
    A class  used to generate a Fedora Object XML, FOXML, file.
    """
    #Define attributes for an object
    activeState = "A"
    inactiveState = "I"
    deletedState = "D"
    
    def __init__(self, state, pid, label, contentModel):
        """
        The constructor takes the following three arguments:
        - state, the state of the object, Active (A), Inactive (I), Deleted (D)
        - pid, the pid of the object
        - label, the label of the object
        - contentModel, the content model used for the object
        """

        baseObject = """<?xml version="1.0" encoding="UTF-8"?>
        <foxml:digitalObject xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" PID="import:1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.fedora.info/definitions/1/0/foxml1-0.xsd">
            <foxml:objectProperties>
                <foxml:property NAME="http://www.w3.org/1999/02/22-rdf-syntax-ns#type" VALUE="FedoraObject"/>
		<foxml:property NAME="info:fedora/fedora-system:def/model#state" VALUE="A"/>
		<foxml:property NAME="info:fedora/fedora-system:def/model#label" VALUE="FOXML Reference Example"/>
		<foxml:property NAME="info:fedora/fedora-system:def/model#contentModel" VALUE="VITAL"/>
            </foxml:objectProperties>
        </foxml:digitalObject>
        """

        pidMaxLength = 64
        labelMaxLength = 255

        if len(label) > labelMaxLength:
            label = label[:labelMaxLength]
            print "Warning: Label for object with PID \"" + pid + "\" has been truncated. Max length is: " + str(labelMaxLength)            
       
        self.xml = libxml2.parseDoc(baseObject)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("//foxml:digitalObject")[0]
        node.setProp("PID", pid)
        
        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME = 'info:fedora/fedora-system:def/model#state']")[0]
        node.setProp("VALUE", state)
        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME = 'info:fedora/fedora-system:def/model#label']")[0]
        node.setProp("VALUE", label)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:objectProperties/foxml:property[@NAME = 'info:fedora/fedora-system:def/model#contentModel']")[0]
        node.setProp("VALUE", contentModel) 

    def addDublinCore(self, dcXML, state):
        """
        Add a Dublin Core data stream, the following arguments are required
        - dcXML, the Dublin Core XML
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" ID="DC" STATE="A" CONTROL_GROUP="X">
                                              <foxml:datastreamVersion ID="DC.0" MIMETYPE="text/xml" LABEL="Dublin Core">
                                                  <foxml:xmlContent>
                                                  </foxml:xmlContent>
                                              </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """)

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream[@ID='DC']")[0]
        node.setProp("STATE", state)

        xpath = "/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion/foxml:xmlContent"
        self.xml = self.mergeXMLDocs(self.xml, dcXML, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")        

    def addInlineXML(self, ident, label, inlineXML, state):
        """
        Add an inline XML data stream, the following arguments are required
        - ident, the ID of the datastream
        - label, the label for the datastream
        - inlineXML, the XML to embed in the file
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" ID="replace-me-please" STATE="A" CONTROL_GROUP="X">
                                              <foxml:datastreamVersion ID="replace-me-please.0" MIMETYPE="text/xml" LABEL="UVA Technical Metadata Record">
                                                  <foxml:xmlContent>
            				
                                                  </foxml:xmlContent>
                                              </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """)

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream[@ID='replace-me-please']")[0]
        node.setProp("ID", ident)

        node.setProp("STATE", state)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']")[0]
        node.setProp("ID", ident + ".0")

        node.setProp("LABEL", label)      

        xpath = "/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='" + ident +".0']/foxml:xmlContent"
        self.xml = self.mergeXMLDocs(self.xml, inlineXML, xpath, self.xpathContext)
	# Serialize self.xml into a temporary Unicode string
	#unicodetransformation = unicode(self.xml.serialize(), "UTF-8")
        #Normailse the unicode
	#import unicodedata
	#unicodetransformation = unicodedata.normalize('NFKC', unicodetransformation)
        #Reparse into self.xml self.xml.parseDoc( XXXXXX )
        #self.xml = libxml2.parseDoc(unicodetransformation.encode("UTF-8"))
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")        


    def addManagedDatastream64(self, ident, label, data, state):
        """
        Add a managed base 64 encoded data stream, the following arguments are required
        - ident, the ID of the datastream
        - label, the label for the datastream
        - data, the datastream to embed in the file - a string
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        import base64  
        data = base64.b64encode(data) 
       
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" ID="%s" STATE="%s" CONTROL_GROUP="M">
                                              <foxml:datastreamVersion ID="%s.0" MIMETYPE="text/xml" LABEL="%s">
                                                  <foxml:contentDigest DIGEST="none" TYPE="DISABLED"/>
                                                   <foxml:binaryContent>
                                                     %s
                                                
                                                   </foxml:binaryContent>
                                             
                                                </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """ % ( ident, state, ident, label,  data))
                                    
                                

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
      
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")        


    def addExternalDataStream(self, ident, mimeType, label, url, state):
        """
        Add an external content datastream the following arguments are required
        - ident, the ID of the datastrem
        - mimeType, the mimeType of the referenced content
        - label, the label for the datastream
        - url, the URL to the content
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" CONTROL_GROUP="E" ID="replace-me-please" STATE="A">
                                              <foxml:datastreamVersion ID="replace-me-please.0" MIMETYPE="image/x-mrsid-image" LABEL="Image of Pavilion III, University of Virginia">
                                                  <foxml:contentLocation REF="http://iris.lib.virginia.edu/mrsid/mrsid_images/iva/archerp01.sid" TYPE="URL"/>
                                              </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """)

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream[@ID='replace-me-please']")[0]
        node.setProp("ID", ident)

        node.setProp("STATE", state)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']/foxml:contentLocation")[0]
        node.setProp("REF", url)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']")[0]
        node.setProp("ID", ident + ".0")

        node.setProp("LABEL", label)

        node.setProp("MIMETYPE", mimeType)

        

    def addRedirectedDataStream(self, ident, mimeType, label, url, state):
        """
        Add a redirected content datastream the following arguments are required
        - ident, the ID of the datastrem
        - mimeType, the mimeType of the referenced content
        - label, the label for the datastream
        - url, the URL to the content
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" CONTROL_GROUP="R" ID="replace-me-please" STATE="A">
                                              <foxml:datastreamVersion ID="replace-me-please.0" MIMETYPE="image/jpeg" LABEL="Architectural Drawing Pavilion III (veryhigh res)">
                                                  <foxml:contentLocation REF="http://icarus.lib.virginia.edu/images/iva/archerd05high.jpg" TYPE="URL"/>
                                              </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """)

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream[@ID='replace-me-please']")[0]
        node.setProp("ID", ident)

        node.setProp("STATE", state)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']/foxml:contentLocation")[0]
        node.setProp("REF", url)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']")[0]
        node.setProp("ID", ident + ".0")

        node.setProp("LABEL", label)

        node.setProp("MIMETYPE", mimeType) 

    def addManagedDataStream(self, ident, mimeType, label, url, state):
        """
        Add a managed content datastream the following arguments are required
        - ident, the ID of the datastrem
        - mimeType, the mimeType of the referenced content
        - label, the label for the datastream
        - url, the URL to the content
        - state, the state of the datastream, Active (A), Inactive (I), Deleted (D)
        """
        boilerplate = libxml2.parseDoc("""<foxml:datastream xmlns:foxml="http://www.fedora.info/resources/faq.shtml#rdfproperties" CONTROL_GROUP="M" ID="replace-me-please" STATE="A">
                                              <foxml:datastreamVersion ID="replace-me-please.0" MIMETYPE="image/jpeg" LABEL="Architectural Drawing Pavilion III (med res)">
                                                  <foxml:contentLocation REF="http://icarus.lib.virginia.edu/images/iva/archerd05medium1.jpg" TYPE="URL"/>
                                              </foxml:datastreamVersion>
                                          </foxml:datastream>
                                       """)

        xpath = "//foxml:digitalObject"        
        self.xml = self.mergeXMLDocs(self.xml, boilerplate, xpath, self.xpathContext)
        self.xpathContext = self.xml.xpathNewContext()
        self.xpathContext.xpathRegisterNs("foxml", "http://www.fedora.info/resources/faq.shtml#rdfproperties")

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream[@ID='replace-me-please']")[0]
        node.setProp("ID", ident)

        node.setProp("STATE", state)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']/foxml:contentLocation")[0]
        node.setProp("REF", url)

        node = self.xpathContext.xpathEval("/foxml:digitalObject/foxml:datastream/foxml:datastreamVersion[@ID='replace-me-please.0']")[0]
        node.setProp("ID", ident + ".0")

        node.setProp("LABEL", label)

        node.setProp("MIMETYPE", mimeType)

    def convertText(self, text):
        """
        Convert a string with embedded unicode characters to have XML entities instead
        - text, the text to convert
        If it works return a string with the characters as XML entities
        If it fails return raise the exception
        """
        try:
            temp = unicode(text, "utf-8")
            fixed = unicodedata.normalize('NFKC', temp).encode('UTF-8')
            return fixed
        except Exception, errorInfo:
            print errorInfo
            print "Unable to convert the Unicode characters to xml character entities"
            raise errorInfo    

    def serialize(self):
        """
        Serialize the FOXML object
        """
        tmp = xml_normalize.normalizeXml(self.xml.serialize())
        return self.convertText(tmp)

    def writeFile(self, fileName):
        """
        Write the FOXML object out to a file, the following argument is required
        - fileName, name of the file to write to
        - NOTE: The namespace used internally by the class is replaced with the one that Fedora expects
        The Fedora Namespace is a relative URL which is not allowed by libxml
        """
        output = open(fileName, 'w')
        tmp = xml_normalize.normalizeXml(self.xml.serialize())
        tmp = tmp.replace("http://www.fedora.info/resources/faq.shtml#rdfproperties", "info:fedora/fedora-system:def/foxml#")
        tmp = self.convertText(tmp)
        output.write(tmp)
        output.close
    def cleanUp(self):
        self.xml.freeDoc()
        
        

    def mergeXMLDocs(self, parent, child, xpath, xpathContext):
        """
        Merge the child XML fragment into the parent XML fragment at the location specified by the xpath
        The following arguments are required
        - parent, the parent XML fragment
        - child, the child XML fragment
        - xpath, the xpath specifying the location of the merge
        - xpathContext, an xpathContext if the parent XML has a namespace
        """
        childutf8 = child.serialize()
        childDoc = libxml2.parseDoc(self.convertText(childutf8))
        childRootNode = childDoc.getRootElement()
 
        if xpathContext == None:
            location = parent.xpathEval(xpath)[0]
            location.addChild(childRootNode)
            return parent
        else:
            location = xpathContext.xpathEval(xpath)[0]
            location.addChild(childRootNode)
            return parent

   
        

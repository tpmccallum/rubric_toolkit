
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
'''
Get ADT HTML using single URL
Name of the script
get_adt_html.py
Location of script
migration_toolkit/adt/python/get_adt_html.py
Purpose of script
The get_adt_html.py script is the Python script that harvests all of the items in an ADT repository. The script captures the metadata between the head tags of the individual ADT items and converts the tags to lowercase. To invoke the script enter the following command in a terminal, note you must issue this command from within the directory that contains the get_adt_html.py script
This script creates a temporary DSpace simple archive, dspaceArchive, in the current directory. Any files the script is unable to locate, will not be created. The user is notified if the files are missing.
Each item is represented by one item directory within dspaceArchive. These files are numbered consecutively; first directory is called 0, 1 and so on. 
The datastreams for each object are stored in the corresponding numbered directory. For example the datastreams in the 0 directory contain three datastreams for this object. They are the two PDF files, 01front.pdf and 02whole.pdf, and a text file containing all of the text extracted from the two PDF files named contents and a temporary xml file, dc_temp.xml,  containing basic dublin core metadata..
Parameters/Arguments
adtUrl
This is the link to the ADT repository that you will be harvesting
Syntax
python get_adt_html.py adtUrl
Example
python get_adt_html.py http://www.an_adt_repository.com.au
'''

import libxml2, urllib2, urlparse, sys, os, os.path, subprocess, re, unicodedata, string, codecs, encodings
sys.path.append("../../utils")
sys.path.append("../../dspace_archive")
import diff_util  
import xml_util 
from dspace_archive import *
import xml_normalize


def getDegreeProgram(content):
    """
    Get the degree program based on the ADT dscription from the
    ADT browse page
    - content, the string to get the Degree Program from
    """
    try:
        temp = content.split(".")
        temp = temp[-1]
        temp = temp.split(",")
        return temp[0].strip()
    except Exception, errorInfo:
        print errorInfo
        print "Unable to determine the degree program from:"
        print content
        return False   
    
def getThesisList(url, html):
    """
    Get the list of Theses available from the browse page
    - html, the html of the browse page
    If the parse works return a dictionary containing URLs and thesis types
    If it fails return false
    """
    try:
        thesisList = []
        xhtml = libxml2.htmlParseDoc(html, None)
        #TODO add a test for this
        anchorTags = xhtml.xpathEval("//a[contains(@href, 'adt-')]")
        for i in range(len(anchorTags)):
            if anchorTags[i].content != "":
                urlSuffix = anchorTags[i].properties.content
                if urlSuffix.find("library/adt/public") != -1:
                    pathList = urlSuffix.split('/')
                    urlSuffix = pathList[5]
                url2 = urlparse.urljoin(url, urlSuffix)
                degreeProgram = getDegreeProgram(anchorTags[i].content)
            if degreeProgram != False:
                thesisList.append([url2, anchorTags[i].content, degreeProgram])
            else:
                return False
        return thesisList
    except Exception, errorInfo:
        print errorInfo
        print "Unable to build the thesis list"
        return False 
    
  

   
def htmlToXML(html):
    xml = libxml2.htmlParseDoc(html, "utf-8")
    headDoc = libxml2.parseDoc("<head/>")
    head = headDoc.getRootElement()
    
    for meta in xml.xpathEval("//meta"):
        meta.setProp("name", meta.prop("name").lower())
        head.addChild(meta)
##    meta = head.newChild(None, "meta", None)
##    meta.setProp("name", "dc.description")
##    meta.setProp("content", degreeProgram)
    return head.serialize()

def createDCXML(html):
    basicDC = htmlToXML(html)
    body = bodyHtmlToXML(html)
    
    dcXml = libxml2.htmlParseDoc(basicDC, "utf-8")
    headDCDoc = libxml2.parseDoc("<head/>")
    headDC = headDCDoc.getRootElement()
           
    for meta in dcXml.xpathEval("//meta"):
        headDC.addChild(meta)
    
    #add faculty to tempxml
    meta = headDC.newChild(None, "meta", None)
    faculty = extractFaculty(body)
    meta.setProp("name", "dc.faculty")
    meta.setProp("content",faculty )
    #add school to tempxml
    meta1 = headDC.newChild(None, "meta", None)
    school = extractSchool(body)
    meta1.setProp("name", "dc.school")
    meta1.setProp("content", school)
    #add degree program
    degreeProgram = extractDegreeProgram(body)
    meta2 = headDC.newChild(None, "meta", None)
    meta2.setProp("name", "dc.degreeprogram")
    meta2.setProp("content", degreeProgram)
    #add thesis type
    thesisType = extractThesisType(body)
    meta3 = headDC.newChild(None, "meta", None)
    meta3.setProp("name", "dc.thesistype")
    meta3.setProp("content", thesisType)
    #add supervisor
    supervisor = extractSupervisor(body)
    meta4 = headDC.newChild(None, "meta", None)
    meta4.setProp("name", "dc.supervisor")
    meta4.setProp("content", supervisor)
    #add lastName
    lastName = extractLastName(body)
    meta5 = headDC.newChild(None, "meta", None)
    meta5.setProp("name", "dc.lastname")
    meta5.setProp("content", lastName)
    #add otherNames
    otherNames = extractOtherNames(body)
    meta6= headDC.newChild(None, "meta", None)
    meta6.setProp("name", "dc.othernames")
    meta6.setProp("content", otherNames)
    
    return headDC.serialize()
    
    
    

def bodyHtmlToXML(html):
    xml = libxml2.htmlParseDoc(html, "utf-8")
    bodyDoc = libxml2.parseDoc("<body/>")
    body = bodyDoc.getRootElement()
    for meta in xml.xpathEval("//h3"):
        body.addChild(meta)
    return body.serialize()

def extractFaculty(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    tdList = bodyXml.xpathEval("//tr[th/text()='Division']/td")
    faculty = tdList[0].content.strip()
    return faculty

def extractSchool(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    tdlist = bodyXml.xpathEval("//tr[th/text()='School']/td")
    school = tdlist[0].content.strip()
    return school

def extractDegreeProgram(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    tdList = bodyXml.xpathEval("//tr[th/text()='Degree Program']/td")
    degreeProgram = tdList[0].content.strip()
    return degreeProgram
    
def extractThesisType(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    tdList = bodyXml.xpathEval("//tr[th/text()='Thesis Type']/td")
    thesisType = tdList[0].content.strip()
    return thesisType

def extractSupervisor(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    supervisorlist = bodyXml.xpathEval("//tr[th/text()='Supervisor']/td")
    supervisor = supervisorlist[0].content.strip()
    return supervisor 

def extractLastName(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    lastnamelist = bodyXml.xpathEval("//table[th/text()='Last Name']/td")
    lastname = lastnamelist[0].content.strip()
    return lastname

def extractOtherNames(body):
    bodyXml = libxml2.htmlParseDoc(body, "utf-8")
    othernameslist = bodyXml.xpathEval("//tr[th/text()='Other Names']/td")
    othernames = othernameslist[0].content.strip()
    return othernames
 


def getPDFUrlList(itemURL,html):
    urls =[]
    xhtml = libxml2.htmlParseDoc(html,None)
    anchors = xhtml.xpathEval("//a")
    for anchor in anchors:
        if anchor.properties.content.endswith(".pdf"):
            url = urlparse.urljoin(itemURL,anchor.properties.content)
            urls.append(url)
    return urls

  
 


def getFile(location):
    try:
        url = urllib2.urlopen(location)
        fileData = url.read()
        url.close()
        return fileData 
    except Exception, errorInfo:
        print errorInfo
        print "Unable to locate, " + location 
        return None
       
    
def convertText(text):
    """
    Convert a string with embedded unicode characters to have XML entities instead
    - text, the text to convert
    If it works return a string with the characters as XML entities
    If it fails return raise the exception
    """
    try:
        normalizedText = unicodedata.normalize('NFKC', text).encode('UTF-8')
        return normalizedText
    except Exception, errorInfo:
        print errorInfo
        print "Unable to convert the Unicode characters to xml character entities"
        raise errorInfo 
    
def decodeString(string):
    try:
        decodedString = string.decode('Cp1252')
        preparedHtml = decodedString.encode("utf-8")
        return preparedHtml 
    except Exception, errorInfo: 
        
        return string 
        print errorInfo
        print "Unable to convert a character in this item to utf-8, this may cause the character to display incorrectly"
        
class BrokenPdfUrlList:
    def __init__(self):
        self.list = []
    def addBrokenPdfUrlToList(self, urlString):
        self.list.append(urlString)  
    def getList(self):
        return self.list
    def printList(self):
        print "The following pdf files were unable to be downloaded, please check the urls in a browser to ensure they exist"
        for i in range(len(self.list)):
            print self.list[i]
   

def main(url):
    #Create a archive and delete and recreate
    newArchive = dspaceArchive("dspaceArchive")
    newArchive.delete()
    newArchive = dspaceArchive("dspaceArchive")
    brokenList = BrokenPdfUrlList()
    browsePage = getFile(url)
    thesisList = getThesisList(url, browsePage)
    print "Number of items to process: " + str(len(thesisList) - 1)
    startNum = str(len(thesisList) - 1)
    thesisNum = 0
    #loop through list and process each item individually
    for thesis in thesisList:
        thesisNum = thesisNum + 1
        print "Processing item: " + thesis[1]
        #get html page
        html = getFile(thesis[0])
        if html != None:
            #decode string using ISO 8859-1 (closest character encoding found, most likely encoding)
            decodedResult = decodeString(html)
            adt_dc = createDCXML(decodedResult)
            
            # item = archive.newIten()
            item = newArchive.newItem()
            # item.addstream("dc_temp.xml", "RUBRIC-temp", adt_dc)
            item.newStream("temp.xml", "RUBRIC-temp", adt_dc)
            # Get the pdfs 
            #download ALL pdfs
            pdfUrlList = getPDFUrlList(thesis[0], html)
            for pdfUrl in pdfUrlList:
                pdfContent = getFile(pdfUrl) 
                if pdfContent != None:
                    pdfFileName = pdfUrl.split("/")[-1] 
                    item.newStream(pdfFileName, "bundle:ORIGINAL", pdfContent)
                else:
                    brokenList.addBrokenPdfUrlToList(pdfUrl)
    #report on broken pdf urls
    brokenList.printList()
        
            
        
    

    
arg = sys.argv[0]
match = re.search("py.test", arg)
if match == None:
    url = sys.argv[1]
    main(url)
    

    
    


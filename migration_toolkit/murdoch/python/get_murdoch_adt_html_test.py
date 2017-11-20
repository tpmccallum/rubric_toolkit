
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

import libxml2, os, os.path, shutil, sys
sys.path.append("../../utils")
sys.path.append("../../dspace_archive")
sys.path.append("get_murdoch_adt_html")
import diff_util
import xml_util
from get_murdoch_adt_html import *

def test_getDegreeProgram():
    degreeProgram = getDegreeProgram("Thompson, Faye Elizabeth. PhD Doctorate, 2001")
    assert degreeProgram == "PhD Doctorate"
    degreeProgram = getDegreeProgram("Roberts, Christopher B. . Masters Thesis, 2002")
    assert degreeProgram == "Masters Thesis"
    degreeProgram = getDegreeProgram("Coker, Rick A.. PhD Doctorate, 2003")
    assert degreeProgram == "PhD Doctorate"
    degreeProgram = getDegreeProgram("Tuan , Tran . PhD Doctorate, 2004")
    assert degreeProgram == "PhD Doctorate"

def test_getThesisList():
    htmlFile = open("html_data/thesis_list_test.html", 'r')
    html = htmlFile.read()
    htmlFile.close()
 
    url = "http://wwwlib.murdoch.edu.au/adt/browse/list/A-D"
    thesisList = getThesisList(url, html)
    #[0] = url [1] = item text [2] = Degree Program
    assert len(thesisList) == 2
    assert thesisList[0][0] == "http://wwwlib.murdoch.edu.au/adt/browse/view/adt-MU20040730.142034"
    assert thesisList[0][1] == " Parasites of Feral Cats and Native Fauna from Western Australia: The Application of Molecular Techniques for the Study of Parasitic Infections in Australian Wildlife"
    assert thesisList[0][2] == "Parasites of Feral Cats and Native Fauna from Western Australia: The Application of Molecular Techniques for the Study of Parasitic Infections in Australian Wildlife"
    assert thesisList[1][0] == "http://wwwlib.murdoch.edu.au/adt/browse/view/adt-MU20040820.120416"
    assert thesisList[1][1] == " Cleanup of the Buriganga River: Integrating the Environment into Decision Making"
    assert thesisList[1][2] == "Cleanup of the Buriganga River: Integrating the Environment into Decision Making"

def test_htmlToXML():
    targetFile = open("xml_data/meta_lowercase.xml", 'r')
    target = targetFile.read()
    htmlFile = open("html_data/thompson-index.html", 'r')
    html = htmlFile.read()
    testThis = xml_util.xml(target) 
    result  = htmlToXML(html)
    assert diff_util.sameXml(target, result)
    
def test_bodyHtmlToXML():
    targetBodyFile = open("xml_data/body_item.xml", 'r')
    targetBody = targetBodyFile.read()
    htmlFile2 = open("html_data/thompson-index.html", 'r')
    bodyHtml = htmlFile2.read()
    testThis2 = xml_util.xml(targetBody)
    resultBody  = bodyHtmlToXML(bodyHtml)
    assert diff_util.sameXml(targetBody,resultBody)
    
def open_body_test_file():
    inputBodyFile = open("xml_data/body_item.xml", 'r')
    bodyfile = inputBodyFile.read()
    return bodyfile
    
def test_extractFaculty():
    bodyForFaculty = open_body_test_file()
    faculty = extractFaculty(bodyForFaculty)
    assert faculty == "Health Sciences"
    
def test_extractSchool():
    bodyForSchool = open_body_test_file()
    school = extractSchool(bodyForSchool)
    assert school == "Veterinary & Biomedical Sciences"
  
def test_extractDegreeProgram():
    bodyForDP = open_body_test_file()
    DP = extractDegreeProgram(bodyForDP)
    assert DP == "Doctor of Philosophy (PhD)"
    
def test_extractThesisType():
    bodyForTT = open_body_test_file()
    TT = extractThesisType(bodyForTT)
    assert TT == 'PhD Doctorate'
    
def test_extractSupervisor():
    bodyForSupervisor = open_body_test_file()
    TT = extractSupervisor(bodyForSupervisor)
    assert TT == 'Professor R. C. Andrew Thompson'
    
def test_extractLastName():
    bodyForLastName = open_body_test_file()
    LN = extractLastName(bodyForLastName)
    assert LN == 'Adams'
    
def test_extractOtherNames():
    bodyForOtherNames = open_body_test_file()
    ON = extractOtherNames(bodyForOtherNames)
    assert ON == 'Peter John'
    
def test_createDCXML():
    htmlFile3 = open("html_data/thompson-index.html", 'r')
    fullHtml = htmlFile3.read()
    dcXML = createDCXML(fullHtml)
    targetFileDC = open("xml_data/DCMurdoch.xml", 'r')
    targetDC = targetFileDC.read()
    #testThis = xml_util.xml(targetDC) 
    assert diff_util.sameXml(targetDC,dcXML)
  

def test_getFile():
    pdfFile = getFile("http://adt.usq.edu.au/adt-QUSQ/uploads/approved/adt-QUSQ20030512.165509/public/01front.pdf")
    assert pdfFile.startswith("%PDF")

    pdfFile = getFile("http://adt.usq.edu.au/adt-QUSQ/uploads/approved/adt-QUSQ20030512.165509/public/notFound.pdf")
    assert pdfFile == None

def test_getPDFUrlList():
    htmlFile = open("html_data/thompson-index.html", 'r')
    html = htmlFile.read()
    htmlFile.close()

    #configOptions = {}
    #configOptions["adt-browse-page"] = "http://adt.usq.edu.au/adt-QUSQ/public/index.html"
    browsepageUrl = "http://wwwlib.murdoch.edu.au/adt/browse/list/A-D"

    urlList = getPDFUrlList(browsepageUrl, html)
    assert len(urlList) == 2
    assert urlList[0] == "http://wwwlib.murdoch.edu.au/adt/pubfiles/adt-MU20040730.142034/01Front.pdf"
    assert urlList[1] == "http://wwwlib.murdoch.edu.au/adt/pubfiles/adt-MU20040730.142034/02Whole.pdf"

    htmlFile = open("html_data/thesis_list_test.html", 'r')
    html = htmlFile.read()
    htmlFile.close()
    urlList1 = getPDFUrlList(browsepageUrl, html)
    assert urlList1 == []
    
def test_BrokenPdfUrlList():
    x = BrokenPdfUrlList()
    x.addBrokenPdfUrlToList("http://bbbroken.pdf")
    list = x.getList()
    assert list[0] == "http://bbbroken.pdf"
    

    
    
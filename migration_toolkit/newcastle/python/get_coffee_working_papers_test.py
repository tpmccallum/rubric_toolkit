
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
sys.path.append("get_adt_html")
import diff_util
from get_coffee_working_papers import *
##
##def test_getDegreeProgram():
##    degreeProgram = getDegreeProgram("Thompson, Faye Elizabeth. PhD Doctorate, 2001")
##    assert degreeProgram == "PhD Doctorate"
##    degreeProgram = getDegreeProgram("Roberts, Christopher B. . Masters Thesis, 2002")
##    assert degreeProgram == "Masters Thesis"
##    degreeProgram = getDegreeProgram("Coker, Rick A.. PhD Doctorate, 2003")
##    assert degreeProgram == "PhD Doctorate"
##    degreeProgram = getDegreeProgram("Tuan , Tran . PhD Doctorate, 2004")
##    assert degreeProgram == "PhD Doctorate"
##
##def test_getThesisList():
##    htmlFile = open("../html_data/thesis_list_test.html", 'r')
##    html = htmlFile.read()
##    htmlFile.close()
## 
##    url = "http://adt.usq.edu.au/adt-QUSQ/public/index.html"
##    thesisList = getThesisList(url, html)
##    #[0] = url [1] = item text [2] = Degree Program
##    assert len(thesisList) == 2
##    assert thesisList[0][0] == "http://adt.usq.edu.au/adt-QUSQ/public/adt-QUSQ20030512.165509/index.html"
##    assert thesisList[0][1] == "Thompson, Faye Elizabeth. PhD Doctorate, 2001"
##    assert thesisList[0][2] == "PhD Doctorate"
##    assert thesisList[1][0] == "http://adt.usq.edu.au/adt-QUSQ/public/adt-QUSQ20030513.152710/index.html"
##    assert thesisList[1][1] == "Basnet, Badri Bahadur . PhD Doctorate, 2002"
##    assert thesisList[1][2] == "PhD Doctorate"
##
def test_htmlToXML():
    #open and read pre saved file for comparing
    #htmlfile = getFile("http://e1.newcastle.edu.au/coffee/templates/wp2.cfm?id=50")
    file = open("../wp2.html", "r")
    readFile = file.read()
    newXml = fetchXml(readFile)
    #newXml = fetchXml("http://e1.newcastle.edu.au/coffee/templates/wp2.cfm?id=50")
    


    
    
    
    
##    comparisonHtmlFile = open("../html_data/thompson-index.html", 'r')
##    html = comparisonHtmlFile.read()
##    result  = htmlToXML(html)
##    
##    assert diff_util.sameXml(testThis, result)
##    
    

##def test_getFile():
##    #open html and write to a file
##    fileHtml = open("../saved_html.html", "w")
##    fileHtml.write(getFile("http://e1.newcastle.edu.au/coffee/templates/wp2.cfm?id=50"))
##    fileHtml.close()
##    #open and read pre saved file for comparing
##    file = open("../wp2.html", "r")
##    fileContents = file.read()
##    #open htmlfile and read
##    fileHtml2 = open("../saved_html.html", "r")
##    htmlFile = fileHtml2.read()
##    #unable to assert this test as the html source code contains the time and date that the page was saved. Will never pass(results were checked manually and passed)
##    #assert fileContents == htmlFile


##def test_getPDFUrlList():
##    htmlFile = open("../html_data/thompson-index.html", 'r')
##    html = htmlFile.read()
##    htmlFile.close()
##
##    #configOptions = {}
##    #configOptions["adt-browse-page"] = "http://adt.usq.edu.au/adt-QUSQ/public/index.html"
##    browsepageUrl = "http://adt.usq.edu.au/adt-QUSQ/public/index.html"
##
##    urlList = getPDFUrlList(browsepageUrl, html)
##    assert len(urlList) == 2
##    assert urlList[0] == "http://adt.usq.edu.au/adt-QUSQ/uploads/approved/adt-QUSQ20030512.165509/public/01front.pdf"
##    assert urlList[1] == "http://adt.usq.edu.au/adt-QUSQ/uploads/approved/adt-QUSQ20030512.165509/public/02whole.pdf"
##
##    htmlFile = open("../html_data/thesis_list_test.html", 'r')
##    html = htmlFile.read()
##    htmlFile.close()
##    urlList1 = getPDFUrlList(browsepageUrl, html)
##    assert urlList1 == []
##
##def test_convertText():
##    rawHtml = open("testdata/rawHtml.html", "r")
##    rawHtml2 = rawHtml.read()
##    decodedText = decodeString(rawHtml2)
##    rawHtml.close()
##    
##    #decodedText1 = convertText(decodedText)
##    #codecs.open("testdata/decodedHtml.html", "w", "utf-8").write(decodedText)
##
##    
    